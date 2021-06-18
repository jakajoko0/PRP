# frozen_string_literal: true

# Interactor to isolate the business logic of Create Bank Payment
class CreateCardPayment
	include Interactor

	def call
		card_payment = CardPayment.new(context.params)
		card_payment.date_entered = DateTime.now
		card_payment.payment_date = DateTime.now
	  card_payment.paid_with = CreditCard.find_by(card_token: context.params[:gms_token]).card_type_and_number
  
		if card_payment.save
			CardPaymentWorker.perform_async(card_payment.id)
			context.card_payment = card_payment
		else
			context.card_payment = card_payment 
			context.fail!
		end
  end


end