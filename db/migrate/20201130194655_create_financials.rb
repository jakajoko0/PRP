class CreateFinancials < ActiveRecord::Migration[6.0]
  def change
    create_table :financials do |t|
    	t.references :franchise, foreign_key: true 
    	t.integer :year
    	t.decimal :acct_monthly, precision: 12, scale: 2, default: 0.00 
    	t.decimal :acct_startup, precision: 12, scale: 2, default: 0.00 
    	t.decimal :acct_backwork, precision: 12, scale: 2, default: 0.00 
    	t.decimal :tax_prep, precision: 12, scale: 2, default: 0.00 
    	t.decimal :payroll_processing, precision: 12, scale: 2, default: 0.00 
    	t.decimal :other_consult, precision: 12, scale: 2, default: 0.00 
    	t.decimal :payroll_operation, precision: 12, scale: 2, default: 0.00 
    	t.decimal :owner_wages, precision: 12, scale: 2, default: 0.00 
    	t.decimal :owner_payroll_taxes, precision: 12, scale: 2, default: 0.00 
    	t.decimal :payroll_taxes_ben_ee, precision: 12, scale: 2, default: 0.00 
    	t.decimal :insurance_business, precision: 12, scale: 2, default: 0.00 
    	t.decimal :supplies, precision: 12, scale: 2, default: 0.00 
    	t.decimal :legal_accounting, precision: 12, scale: 2, default: 0.00 
    	t.decimal :marketing, precision: 12, scale: 2, default: 0.00 
    	t.decimal :rent, precision: 12, scale: 2, default: 0.00 
    	t.decimal :outside_labor, precision: 12, scale: 2, default: 0.00 
    	t.decimal :vehicles, precision: 12, scale: 2, default: 0.00 
    	t.decimal :travel, precision: 12, scale: 2, default: 0.00 
    	t.decimal :utilities, precision: 12, scale: 2, default: 0.00 
    	t.decimal :licenses_taxes, precision: 12, scale: 2, default: 0.00 
    	t.decimal :postage, precision: 12, scale: 2, default: 0.00 
    	t.decimal :repairs, precision: 12, scale: 2, default: 0.00 
    	t.decimal :interests, precision: 12, scale: 2, default: 0.00 
    	t.decimal :meals_entertainment, precision: 12, scale: 2, default: 0.00 
    	t.decimal :bank_charges, precision: 12, scale: 2, default: 0.00 
    	t.decimal :contributions, precision: 12, scale: 2, default: 0.00 
    	t.decimal :office, precision: 12, scale: 2, default: 0.00 
    	t.decimal :miscellaneous, precision: 12, scale: 2, default: 0.00 
    	t.decimal :equipment_lease, precision: 12, scale: 2, default: 0.00 
    	t.decimal :dues_subscriptions, precision: 12, scale: 2, default: 0.00 
    	t.decimal :bad_debt, precision: 12, scale: 2, default: 0.00 
    	t.decimal :continuing_ed, precision: 12, scale: 2, default: 0.00 
    	t.decimal :property_tax, precision: 12, scale: 2, default: 0.00 
    	t.decimal :telephone_data_internet, precision: 12, scale: 2, default: 0.00 
    	t.decimal :software, precision: 12, scale: 2, default: 0.00 
    	t.decimal :royalties, precision: 12, scale: 2, default: 0.00 
    	t.decimal :marketing_material, precision: 12, scale: 2, default: 0.00 
    	t.decimal :owner_health_ins, precision: 12, scale: 2, default: 0.00 
    	t.decimal :owner_vehicle, precision: 12, scale: 2, default: 0.00 
    	t.decimal :owner_ira_contrib, precision: 12, scale: 2, default: 0.00 
    	t.decimal :amortization, precision: 12, scale: 2, default: 0.00 
    	t.decimal :depreciation, precision: 12, scale: 2, default: 0.00 
    	t.decimal :payroll_process_fees, precision: 12, scale: 2, default: 0.00 
    	t.decimal :other_income, precision: 12, scale: 2, default: 0.00 
    	t.decimal :interest_income, precision: 12, scale: 2, default: 0.00 
    	t.decimal :net_gain_asset, precision: 12, scale: 2, default: 0.00 
    	t.decimal :casualty_gain, precision: 12, scale: 2, default: 0.00 
    	t.decimal :other_expense_income, precision: 12, scale: 2, default: 0.00 
    	t.decimal :prov_income_tax, precision: 12, scale: 2, default: 0.00 
    	t.string  :other1_desc
    	t.decimal :other1, precision: 12, scale: 2, default: 0.00 
    	t.string  :other2_desc
    	t.decimal :other2, precision: 12, scale: 2, default: 0.00 
    	t.string  :other3_desc
    	t.decimal :other3, precision: 12, scale: 2, default: 0.00 
    	t.integer :monthly_clients
    	t.decimal :total_monthly_fees, precision: 12, scale: 2, default: 0.00 
    	t.integer :quarterly_clients
    	t.decimal :total_quarterly_fees, precision: 12, scale: 2, default: 0.00 
    	t.timestamps


    end
  end
end
