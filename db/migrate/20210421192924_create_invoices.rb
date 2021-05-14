class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
    	t.references :franchise, foreign_key: true
    	t.datetime :date_entered
    	t.datetime :date_posted
    	t.integer :paid , default: 0
    	t.string :note
    	t.string :slug
    	t.integer :admin_generated
      t.timestamps
    end
  end
end
