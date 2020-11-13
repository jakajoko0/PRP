class CreateWebsitePreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :website_preferences do |t|
    	t.references :franchise, foreign_key: true
    	t.integer :website_preference
    	t.string :payment_token
    	t.integer :payment_method
    	t.timestamps
    end
  end
end
