class UpdateFinancial
	include Interactor::Organizer
	organize ModifyFinancial, CreateEventLog
end
