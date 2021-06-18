class DatedBankPaymentSettlementWorker

  include Sidekiq::Worker 
 
  def perform
    today = Date.today
    yesterday = (today - 1).strftime("%Y-%m-%d")
    date_15 = (today - 15).strftime("%Y-%m-%d")
    date_30 = (today - 30).strftime("%Y-%m-%d")
    date_60 = (today - 60).strftime("%Y-%m-%d")

    dated_reconciliation(yesterday)
    dated_reconciliation(date_15)
    dated_reconciliation(date_30)
    dated_reconciliation(date_60)
  end

  private 
  
  def dated_reconciliation(the_date)
    @settlement_log = []
    @number_of_items = 0
     
    gulf = GulfApi::Client.new

    begin
      #Call the Transaction Response method
      response = gulf.instant_transaction_response_by_date(the_date)     
      
      data = response.to_array(:instant_transaction_response_by_date_response, :instant_transaction_response_by_date_result, :array_of_transactions, :one_time_transaction)
   
      #If we have transactions in the response
      if data.length > 0 
        number_of_items = data.length
        #Loop through them
        data.each do |trans|
          update_bank_payment(d)
        end
           
        if @settlement_log.length > 0 
          TransmissionMailer.settlement_notice(@settlement_log,the_date.to_date).deliver_now
        end
      end
    #If an error occurs transmitting to Gulf
    rescue GulfApi::Client::GulfAPIError => e
      TransmissionMailer.error_gulf(e).deliver_now
    end
  
  end

  def update_bank_payment(trans) 
    return unless trans[:transaction_type] != 'CC Sale'
    processed = 0
    #Grab the PRP BankPayment ID
    prp_id = trans[:reference_id]
    #Grab the Gulf ID
    gulf_id = d[:transaction_id]

    payment = BankPayment.find_by id: prp_id , reference_id: gulf_id
    if payment.nil?
      TransmissionMailer.error_not_found(d).deliver_now
    else
      #We only update payments that are waiting for an update  
      if payment.transit?
        processed = 1
        case trans[:transaction_state]
        when 'Approved'
          payment.date_approved = DateTime.now
          payment.status = "approved"
          payment.note = "#{trans[:transaction_state]} , #{trans[:state_reason]}"
        when 'Pending' 
          payment.status = "transit"
          payment.note = "#{trans[:transaction_state]} , #{trans[:state_reason]}"
        when 'Declined'
          payment.note = "#{trans[:transaction_state]} , #{trans[:state_reason]}"
          payment.status = "declined"
          payment.prp_transactions.destroy_all
          process_invoice(payment) if payment.invoice_payment == 1

        when 'Error'
          payment.note = "Error: #{trans[:state_reason]}"
          payment.status = "error"
          payment.prp_transactions.destroy_all
          process_invoice(payment) if payment.invoice_payment == 1
          TransmissionMailer.error_transaction(trans).deliver_now
        end
        
        if payment.save
          BankPaymentMailer.status_change_notice(payment).deliver_now 
        end        
      end

      #Log the payment and status for the admin email
      @settlement_log << SettlementLog.new(trans[:transaction_id], trans[:reference_id],payment.franchise.number_and_name,trans[:date_of_transaction], trans[:transaction_type], trans[:transaction_amount],payment.paid_with, trans[:transaction_state] , trans[:state_reason], processed)
    end
  end

  def process_invoice(payment)
    Invoice.find(payment.invoice_id).update_columns(paid: 0, date_posted: nil)
  end
end