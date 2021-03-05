class AddSlugToRemittances < ActiveRecord::Migration[6.1]
  def change
  	add_column :remittances, :slug , :string, unique: :true
  end
end
