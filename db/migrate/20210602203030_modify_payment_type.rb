class ModifyPaymentType < ActiveRecord::Migration[6.1]
  def change
  	change_column :payments, :type, :string
  end
end
