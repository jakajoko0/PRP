class AddMinRoyToFranchise < ActiveRecord::Migration[6.1]
 def change
    add_column :franchises , :minimum_royalty , :decimal, precision: 10, scale: 2, default: 0.00
  end
end
