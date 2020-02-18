class AddInsurance < ActiveRecord::Migration[6.0]
  def change
  	create_table :insurances do |t|
  		t.references :franchise, foreign_key: true
  		t.integer :eo_insurance, default: 0
  		t.integer :gen_insurance, deafult: 0
  		t.integer :other_insurance, default: 0
  		t.string :other_description
  		t.date :eo_expiration
  		t.date :gen_expiration
  		t.date :other_expiration
  	end

  end
end
