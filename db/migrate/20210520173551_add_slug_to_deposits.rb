class AddSlugToDeposits < ActiveRecord::Migration[6.1]
  def change
  	add_column :deposit_trackings , :slug , :string, unique: :true
  end
end
