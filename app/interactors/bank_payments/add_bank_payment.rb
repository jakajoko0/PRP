# frozen_string_literal: true

# Interactor to isolate the business logic of Create Bank Payment
class AddBankPayment
	include Interactor

	def call
		bank_payment = BankPayment.new(context.params)
		bank_payment.set_dates(context.params[:payment_date])
	  bank_payment.paid_with = BankAccount.find_by(bank_token: context.params[:gms_token]).bank_name_and_number

		if bank_payment.save
			context.bank_payment = bank_payment
		else
			context.bank_payment = bank_payment 
			context.fail!
		end
  end

  def rollback
  	context.bank_payment.destroy
  end


end