class AddTimezonesToUserAdmins < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :time_zone, :string, default: "UTC"
  	add_column :admins, :time_zone, :string, default: "UTC"
  end
end
