class CorrectionToRefFranchiseGroups < ActiveRecord::Migration[6.1]
  def change
    remove_reference :franchise_group_details, :franchise_group_masters
    add_reference :franchise_group_details, :franchise_group_master

  end
end
