# frozen_string_literal: true

# Interactor to isolate the business logic of Create Bank Payment
class DeleteCheckPayment
	include Interactor

	def call
		check_payment = context.check_payment
		check_payment.status = "deleted"
		
		if check_payment.save
		  check_payment.prp_transactions.destroy_all 
		  if check_payment.invoice_payment == 1 
		  	Invoice.find(check_payment.invoice_id).update_columns(paid: 0, date_posted: nil)
		  end
			CheckPaymentMailer.delete_notice(check_payment).deliver_now
			context.check_payment = check_payment
		else
			context.check_payment = check_payment 
			context.fail!
		end
  end
end