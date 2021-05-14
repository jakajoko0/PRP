class CreateInvoice
	include Interactor::Organizer
	organize AddInvoice, AddInvoiceReceivables, CreateEventLog
end