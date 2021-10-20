class SimulatePaymentUpdate
	def self.update_bank_payment(bp_id, status) 
   
    payment = BankPayment.find_by id: bp_id
    if payment.nil?
      return "Payment Not Found"
    else
      #We only update payments that are waiting for an update  

      if payment.transit?
      	puts "In Transit"
        processed = 1
        case status
        when 'Approved'
        	puts "Apprioving"
          payment.date_approved = DateTime.now
          payment.status = "approved"
          payment.note = "#{status} , Checking Withdrawal"
          #process_invoice(payment) if payment.invoice_payment?
        when 'Pending' 
        	puts "Pending"
          payment.status = "transit"
          payment.note = "#{status} , Posted, Awaiting Response From Bank"
          #process_invoice(payment) if payment.invoice_payment?
        when 'Declined'
        	puts "Declining"
          payment.note = "#{status} , Insufficient Funds"
          payment.status = "declined"
          payment.prp_transactions.destroy_all
          #unprocess_invoice(payment) if payment.invoice_payment?

        when 'Error'
        	puts "Erroring"
          payment.note = "Error: Invalid Account Number"
          payment.status = "error"
          payment.prp_transactions.destroy_all
          #unprocess_invoice(payment) if payment.invoice_payment?
          #TransmissionMailer.error_transaction(trans).deliver_now
        end
        
        if payment.save
          #BankPaymentMailer.status_change_notice(payment).deliver_now 

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
      #@settlement_log << SettlementLog.new(trans[:transaction_id], trans[:reference_id],payment.franchise.number_and_name,trans[:date_of_transaction], trans[:transaction_type], trans[:transaction_amount],payment.paid_with, trans[:transaction_state] , trans[:state_reason], processed)
    end
  end

  private

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