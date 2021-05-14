class UpdateInvoice
  include Interactor::Organizer
  organize ModifyInvoice, AddInvoiceReceivables
end