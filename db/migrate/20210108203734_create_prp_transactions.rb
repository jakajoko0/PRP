class CreatePrpTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :prp_transactions do |t|
    	t.references :franchise, foreign_key: true 
    	t.datetime :date_posted
    	t.integer :trans_type, null: false 
    	t.string :trans_code, null: false
    	t.string :trans_description, null: true 
    	t.decimal :amount, precision: 12, scale: 2, null: false, default: 0.00
      t.timestamps
    end
  end
end
