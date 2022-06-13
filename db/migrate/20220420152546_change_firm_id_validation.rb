class ChangeFirmIdValidation < ActiveRecord::Migration[6.1]
  def change
    change_column :franchises, :firm_id, :string,  null: true
    change_column :franchises, :phone, :string, null: true
  end
end
