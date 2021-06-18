# frozen_string_literal: true

# Interactor to isolate the business logic of Create Bank Payment
class UpdateCheckPayment
	include Interactor::Organizer
	organize ModifyCheckPayment, AddCheckTransaction, UpdateCkMail
end
