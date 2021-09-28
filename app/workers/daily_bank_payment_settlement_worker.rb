class DailyBankPaymentSettlementWorker
  include Sidekiq::Worker 

  def perform
    @settlement_log = []
    number_of_items = 0
    
    gulf = GulfApi::Client.new
    
    begin
      #Call the Transaction Response method (will retrieve all transactions ready that were not processed yet)
      response = gulf.instant_transaction_response
        
      #Convert the response to an array for processing
      data = response.to_array(:instant_transaction_response_response, :instant_transaction_response_result, :array_of_transactions, :one_time_transaction)
      
      #If we have transactions in the response
      if data.length > 0 
        
        #Keep track of how many we had
        number_of_items = data.length
        
        #Loop through the transactions to process them / or not
        data.each do |trans|
          update_bank_payment(d)
        end

        if @settlement_log.length > 0 
          TransmissionMailer.settlement_notice(@settlement_log,Date.today).deliver_now
        end
      end
    
    #If an error occurs transmitting to Gulf
    rescue GulfApi::Client::GulfAPIError => e
      TransmissionMailer.error_gulf(e).deliver_now
    end
  end 

  private

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
          #process_invoice(payment) if payment.invoice_payment?
        when 'Pending' 
          payment.status = "transit"
          payment.note = "#{trans[:transaction_state]} , #{trans[:state_reason]}"
          #process_invoice(payment) if payment.invoice_payment?
        when 'Declined'
          payment.note = "#{trans[:transaction_state]} , #{trans[:state_reason]}"
          payment.status = "declined"
          payment.prp_transactions.destroy_all
          #unprocess_invoice(payment) if payment.invoice_payment?

        when 'Error'
          payment.note = "Error: #{trans[:state_reason]}"
          payment.status = "error"
          payment.prp_transactions.destroy_all
          #unprocess_invoice(payment) if payment.invoice_payment?
          TransmissionMailer.error_transaction(trans).deliver_now
        end
        
        if payment.save
          BankPaymentMailer.status_change_notice(payment).deliver_now 

          if payment.approved? || payment.transit? 
            process_invoice if payment.invoice_payment?
          else
            if payment.declined? || payment.error?
              unprocess_invoice if payment.invoice_payment?
            end
          end
        end        
      end

      #Log the payment and status for the admin email
      @settlement_log << SettlementLog.new(trans[:transaction_id], trans[:reference_id],payment.franchise.number_and_name,trans[:date_of_transaction], trans[:transaction_type], trans[:transaction_amount],payment.paid_with, trans[:transaction_state] , trans[:state_reason], processed)
    end
  end


  def unprocess_invoice(payment)
    invoice = Invoice.find(payment.invoice_id)
    invoice.update_columns(paid: 0, date_posted: nil)
    if invoice.invoice_type == "web_payment"
      WebsitePayment.find_by(invoice_id: invoice.id).update_columns(status: "declined")
    end
  end

  def process_invoice(payment)
    invoice = Invoice.find(payment.invoice_id)
    if invoice.invoice_type = "web_payment"
      if payment.status == "approved"
        WebsitePayment.find_by(invoice_id: invoice.id ).update_columns(status: "processed")
      end

      if payment.status == "transit"
        WebsitePayment.find_by(invoice_id: invoice.id ).update_columns(status: "processing")
      end
    end
  end
end



