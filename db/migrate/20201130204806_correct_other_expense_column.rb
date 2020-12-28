class CorrectOtherExpenseColumn < ActiveRecord::Migration[6.0]
  def change
  	rename_column :financials, :other_expense_income, :other_expense
  end
end
