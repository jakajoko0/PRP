class CreateRegionStates < ActiveRecord::Migration[6.1]
  def change
    create_table :region_states do |t|
      t.references :region, foreign_key: true
      t.string :state_abb
      t.string :state
      t.timestamps
    end
  end
end
