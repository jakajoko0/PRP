class AddSlugToFinancials < ActiveRecord::Migration[6.0]
  def change
  	add_column :financials, :slug , :string, unique: :true
  end
end
