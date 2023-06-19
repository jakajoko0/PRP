class RemoveRequiredFranchiseFields < ActiveRecord::Migration[6.1]
  def change
    change_column_null :franchises, :area, true
    change_column_null :franchises, :mast, true
    change_column_null :franchises, :region, true
    change_column_null :franchises, :office, true
    change_column_null :franchises, :lastname, true
    change_column_null :franchises, :firstname, true
  end
end
