# frozen_string_literal: true

# Interactor to isolate the business logic of Create Bank Payment
class AddCheckPayment
	include Interactor

	def call
		check_payment = CheckPayment.new(context.params)
		if context.user.class == Admin 
			check_payment.set_dates(context.params[:date_entered],context.params[:date_approved])
		end
	  check_payment.paid_with = "Check number #{check_payment.check_number}"

		if check_payment.save
			if check_payment.invoice_payment == 1 
				Invoice.find(check_payment.invoice_id).update_columns(paid: 1, date_posted: DateTime.now)
			end
			context.check_payment = check_payment
		else
			context.check_payment = check_payment 
			context.fail!
		end
  end

  def rollback
  	context.check_payment.destroy
  end


end