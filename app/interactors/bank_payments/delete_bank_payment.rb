# frozen_string_literal: true

# Interactor to isolate the business logic of Create Bank Payment
class DeleteBankPayment
	include Interactor

	def call
		bank_payment = context.bank_payment
		bank_payment.status = "deleted"
		
		if bank_payment.save
			#Destroy the payment transaction 
		  bank_payment.prp_transactions.destroy_all 
		  #Update the invoice as unpaid if need be
		  if bank_payment.invoice_payment == 1
		  	Invoice.find(bank_payment.invoice_id).update_columns(paid: 0, date_posted: nil)
		  end

			BankPaymentMailer.delete_notice(bank_payment).deliver_now
			context.bank_payment = bank_payment
		else
			context.bank_payment = bank_payment 
			context.fail!
		end
  end
end