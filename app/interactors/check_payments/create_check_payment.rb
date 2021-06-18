# frozen_string_literal: true

# Interactor to isolate the business logic of Create Bank Payment
class CreateCheckPayment
	include Interactor::Organizer
	organize AddCheckPayment, AddCheckTransaction, SendCkMail 
end

