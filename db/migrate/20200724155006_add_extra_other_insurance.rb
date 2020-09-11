class AddExtraOtherInsurance < ActiveRecord::Migration[6.0]
  def change
  	add_column :insurances, :other2_insurance, :integer,  default: 0
  	add_column :insurances, :other2_description, :string
  	add_column :insurances, :other2_expiration, :date
  end
end
