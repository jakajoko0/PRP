class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :franchise_group_masters do |t|
      t.string :group_handle, null: false
      t.string :group_description, null: false
      t.timestamps
    end

    add_index(:franchise_group_masters, [:group_handle], unique:true, name:'franchise_group_master_index')     

    create_table :franchise_group_details do |t|
      t.references :franchise_group_masters, foreign_key: true
      t.string :franchise_number
      t.integer :franchise_id
    end

    add_index(:franchise_group_details, [:franchise_group_masters_id, :franchise_id], unique:true, name:'franchise_group_detail_index')     

  end
end
