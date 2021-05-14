class CreateInvoiceItems < ActiveRecord::Migration[6.1]
  def change
    create_table :invoice_items do |t|
    	t.references :invoice, foreign_key: true
    	t.string :code, null: false
    	t.decimal :amount, precision: 12, scale: 2, null: false, default: 0.00
      t.timestamps
    end
  end
end
