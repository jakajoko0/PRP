class AddFranchiseNumberToRemittances < ActiveRecord::Migration[6.1]
  def change
    add_column :remittances, :franchise_number , :string
  end

  
end
