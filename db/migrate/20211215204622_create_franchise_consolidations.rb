class CreateFranchiseConsolidations < ActiveRecord::Migration[6.1]
  def change
    create_table :franchise_consolidations do |t|
      t.references :franchise, foreign_key: true
      t.string :franchise_number
      t.timestamps
    end
  end
end
