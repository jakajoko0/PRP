class CreateDepositTrackings < ActiveRecord::Migration[6.1]
  def change
    create_table :deposit_trackings do |t|
    	t.references :franchise, foreign_key: true
    	t.integer :year, null: false
    	t.integer :month, null: false 
    	t.date :deposit_date, null: false
    	t.decimal :total_deposit, precision: 12, scale: 2, null: false, default: 0.00
    	t.decimal :accounting, precision: 12, scale: 2, null: false, default: 0.00
    	t.decimal :backwork, precision: 12, scale: 2, null: false, default: 0.00
    	t.decimal :consulting, precision: 12, scale: 2, null: false, default: 0.00
    	t.decimal :excluded, precision: 12, scale: 2, null: false, default: 0.00
    	t.decimal :other1, precision: 12, scale: 2, null: false, default: 0.00
    	t.decimal :other2, precision: 12, scale: 2, null: false, default: 0.00
    	t.decimal :payroll, precision: 12, scale: 2, null: false, default: 0.00
    	t.decimal :setup, precision: 12, scale: 2, null: false, default: 0.00
    	t.decimal :tax_preparation, precision: 12, scale: 2, null: false, default: 0.00
        t.timestamps
    end
  end
end
