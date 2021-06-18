# frozen_string_literal: true

# Interactor to isolate the business logic of Create Bank Payment
class ModifyCheckPayment

	include Interactor

	def call
		check_payment = context.check_payment
		check_payment.assign_attributes(context.params)
		
		if context.user.class == Admin 
		  check_payment.set_dates(context.params[:date_entered], context.params[:date_approved])
		end
	  check_payment.paid_with = "Check Number #{check_payment.check_number}"

		if check_payment.save 
			context.check_payment = check_payment
		else
			context.check_payment = check_payment 
			context.fail!
		end
  end
end