# frozen_string_literal: true

# Interactor to isolate the business logic of Create Bank Payment
class UpdateBankPayment
	include Interactor::Organizer
	organize ModifyBankPayment, AddPaymentTransaction, UpdateBpMail
end
