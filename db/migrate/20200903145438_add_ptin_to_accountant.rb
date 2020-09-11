class AddPtinToAccountant < ActiveRecord::Migration[6.0]
  def change
  	add_column :accountants, :ptin, :string, limit: 8
  end
end
