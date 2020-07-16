class AddSlugsToTables < ActiveRecord::Migration[6.0]
  def change
  	add_column :franchises, :slug , :string, unique: :true
  	add_column :accountants, :slug , :string, unique: :true
  	add_column :insurances, :slug, :string, unique: :true
  	add_column :users, :slug , :string, unique: :true
  	add_column :admins, :slug , :string, unique: :true
  end
end
