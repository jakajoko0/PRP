class AddSlugToBankAccounts < ActiveRecord::Migration[6.0]
  def change
  	add_column :bank_accounts, :slug , :string, unique: :true
  end
end
