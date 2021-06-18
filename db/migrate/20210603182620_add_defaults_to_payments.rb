class AddDefaultsToPayments < ActiveRecord::Migration[6.1]
  def change
  	change_column :payments, :invoice_payment, :integer,  default: 0 
  	change_column :payments, :invoice_id, :integer, default: 0 
  end
end
