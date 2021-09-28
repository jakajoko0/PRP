class CreateWebsitePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :website_payments do |t|
      t.references :franchise, foreign_key: true
      t.integer :year
      t.integer :month
      t.decimal :fees, precision: 10, scale: 2, default: 0
      t.integer :payment_type, default: 0
      t.integer :status, default: 0
      t.string  :gms_token
      t.integer :invoice_id
      t.timestamps
    end
  end
end
