class RemoveNullFromFranchise < ActiveRecord::Migration[6.1]
  def change
    change_column :franchises, :city, :string, null: true
    change_column :franchises, :state, :string, null: true
    change_column :franchises, :zip_code, :string, null: true
    change_column :franchises, :email, :string, null: true
    
  end
end
