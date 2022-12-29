class AddFinancialFields < ActiveRecord::Migration[6.1]
  def change
    add_column :financials, :erc, :decimal, precision: 12, scale: 2, default: 0
    add_column :financials, :ind_tax_returns, :integer, default: 0
    add_column :financials, :ind_tax_returns_revenues, :decimal, precision: 12, scale: 2, default: 0
    add_column :financials, :entity_tax_returns, :integer, default: 0
    add_column :financials, :entity_tax_returns_revenues, :decimal, precision: 12, scale: 2, default: 0

  end
end
