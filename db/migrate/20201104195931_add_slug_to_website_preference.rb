class AddSlugToWebsitePreference < ActiveRecord::Migration[6.0]
  def change
  	add_column :website_preferences, :slug , :string, unique: :true
  end
end
