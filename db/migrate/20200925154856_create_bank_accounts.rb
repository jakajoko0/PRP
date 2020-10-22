class CreateBankAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_accounts do |t|
    	t.references :franchise, foreign_key: true
    	t.string :bank_name
    	t.string :last_four
    	t.string :account_type
    	t.string :bank_token
    end
  end
end
