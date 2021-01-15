class AddTransacitonableTransaction < ActiveRecord::Migration[6.1]
  def change
  	add_reference :prp_transactions, :transactionable, polymorphic: true, index: true
  end
end
