class TransferBankPaymentWorker
  include Sidekiq::Worker 

  def perform

    translog = []
    number_of_items = 0
    target_date = Time.now

    gulf = GulfApi::Client.new
    #Grab the Bank Payments ready to transfer to Gulf (pending status)
    bank_payments = BankPayment.to_transfer(target_date)

    #Keep track of how many transactions we sent
    number_of_items = bank_payments.size
    
    #If we have transactions to send
    if bank_payments.size  > 0
      
      #For each payment needed to be submitted
      bank_payments.each do |payment|
        @bp = payment
        
        begin  
          #Send the Bank Payment to Gulf
          response = gulf.token_transaction(@bp.gms_token,@bp.amount,@bp.id)     
          #Grab the response data  
          data = response.to_array(:token_transaction_response, :token_transaction_result).first
          #Update the bankpayment with proper status
          update_bank_payment(data)
        
        #If an error occurs transmitting to Gulf
        rescue GulfApi::Client::GulfAPIError => e
          #We leave the status to pending to try again
          @bp.status = "pending"
        end  
        
        if @bp.save
          BankPaymentMailer.status_change_notice(@bp).deliver_now
        end

        #Log the payment and status for the admin email
        translog << TransLog.new(@bp.id,@bp.reference_id,@bp.franchise.number_and_name,@bp.date_entered,@bp.amount,@bp.paid_with,@bp.note)

      end
      #Once all transfers are done, we send an email to admin to let them know with the transaction log
      TransmissionMailer.transmission_notice(number_of_items,translog).deliver_now
    end

  end

  def update_bank_payment(data)
    @bp.reference_id = data[:transaction_id]
    @bp.payment_date = Time.now
    #Depending on the Transaction State we change the approved flag and description
    case data[:transaction_state] 
    when 'Approved'
      @bp.date_approved = DateTime.now
      @bp.status = "approved"
      @bp.note = data[:transaction_state] 
    when 'Pending' 
      @bp.status = "transit"
      @bp.note = data[:transaction_state] + " , "+data[:state_reason]
    when 'Declined'
      @bp.note = data[:transaction_state] + " , "+data[:state_reason]
      @bp.status = "declined"
      @bp.prp_transactions.destroy_all
    when 'Error'
      @bp.note = 'Error: ' + data[:state_reason]
      @bp.status = "error"
      @bp.prp_transactions.destroy_all
      TransmissionMailer.error_notice(data).deliver_now
    end 

  end
  

end

