class AddInvoiceTypeToInvoice < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :invoice_type, :integer, default: 0
  end
end
