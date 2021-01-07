class CreateTransactionCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_codes do |t|
    	t.string :code
    	t.integer :trans_type
    	t.string :description
    	t.boolean :show_in_royalties, null: false, default: false
    	t.boolean :show_in_invoicing, null: false, default: false

    end
  end
end
