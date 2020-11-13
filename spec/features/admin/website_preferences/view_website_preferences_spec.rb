require 'rails_helper'

RSpec.feature "Feature - Viewing Website Preferences", :type => :feature do 
  let!(:admin) {create(:admin)}	
  data = [{firstname: "Daniel", lastname: "Grenier"},{firstname: "Daniel", lastname: "Grenon"}, {firstname: "Daniel", lastname: "Grennier"} ]
  let!(:franchises) {data.map {|d| create(:franchise, d)}}
  let!(:website_preferences) {franchises.map {|f| create(:website_preference, :ach,  franchise_id: f.id )}}

  
  scenario "Admin User Can view all Website Preference" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_website_preferences_path
    website_preferences.each do |wp|
      expect(page).to have_content(wp.franchise.lastname)
    end
  
  end
end
