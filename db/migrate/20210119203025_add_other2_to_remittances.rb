class AddOther2ToRemittances < ActiveRecord::Migration[6.1]
  def change
  	add_column :remittances, :other2, :decimal, precision: 10, scale: 2, default: 0.00
  end
end
