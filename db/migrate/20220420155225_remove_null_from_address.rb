class RemoveNullFromAddress < ActiveRecord::Migration[6.1]
  def change
     change_column :franchises, :address, :string, null: true
  end
end
