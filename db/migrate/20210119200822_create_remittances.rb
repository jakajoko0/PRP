class CreateRemittances < ActiveRecord::Migration[6.1]
  def change
    create_table :remittances do |t|
    	t.references :franchise, foreign_key: true
    	t.integer :year
    	t.integer :month
    	t.integer :status
    	t.datetime :date_received
    	t.datetime :date_posted
    	t.decimal :accounting, precision: 10, scale: 2, default: 0.00
    	t.decimal :backwork, precision: 10, scale: 2, default: 0.00
    	t.decimal :consulting, precision: 10, scale: 2, default: 0.00
    	t.decimal :excluded, precision: 10, scale: 2, default: 0.00
    	t.decimal :other1, precision: 10, scale: 2, default: 0.00
    	t.decimal :payroll, precision: 10, scale: 2, default: 0.00
    	t.decimal :setup, precision: 10, scale: 2, default: 0.00
    	t.decimal :tax_preparation, precision: 10, scale: 2, default: 0.00
    	t.decimal :calculated_royalty , precision: 10, scale: 2, default: 0.00
    	t.decimal :minimum_royalty, precision: 10, scale: 2, default: 0.00
    	t.decimal :royalty, precision: 10, scale: 2, default: 0.00
    	t.string :credit1
    	t.decimal :credit1_amount, precision: 10, scale: 2 , default: 0.00
    	t.string :credit2
    	t.decimal :credit2_amount, precision: 10, scale: 2, default: 0.00
    	t.string :credit3
    	t.decimal :credit3_amount, precision: 10, scale: 2, default: 0.00
    	t.string :credit4
    	t.decimal :credit4_amount, precision: 10, scale: 2, default: 0.00
    	t.integer :late
    	t.string :late_reason
    	t.decimal :late_fees, precision: 10, scale: 2, default: 0.00
    	t.string :payroll_credit_desc
    	t.decimal :payroll_credit_amount, precision: 10, scale: 2, defualt: 0.00
    	t.integer :confirmation
      t.timestamps
    end

    add_index :remittances, :year 
    add_index :remittances, :month 
    add_index :remittances, [:franchise_id, :year, :month], unique: true
  end
end
