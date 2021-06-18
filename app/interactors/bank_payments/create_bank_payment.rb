# frozen_string_literal: true

# Interactor to isolate the business logic of Create Bank Payment
class CreateBankPayment
	include Interactor::Organizer
	organize AddBankPayment, AddPaymentTransaction, SendBpMail 
end

