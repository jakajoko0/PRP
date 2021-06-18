class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
    	t.references :franchise, foreign_key: true 
    	t.integer :type, null: false 
    	t.decimal :amount, precision: 12, scale: 2, null: false, default: 0.00
    	t.decimal :fees, precision: 12, scale: 2, default: 0.00
    	t.integer :status, null: false 
    	t.datetime :date_entered
    	t.datetime :date_approved
    	t.datetime :payment_date
    	t.string :reference_id 
    	t.string :gms_token 
    	t.string :paid_with 
    	t.string :note
    	t.integer :invoice_payment 
    	t.integer :invoice_id
    	t.string :check_number
      t.timestamps
    end
  end
end
