# frozen_string_literal: true

# Interactor chain to create an invoice
class CreateInvoice
  include Interactor::Organizer
  organize AddInvoice, AddInvoiceReceivables, CreateEventLog
end
