require 'rails_helper'

RSpec.feature "Adding Franchises", :type => :feature do 
  let!(:admin) {create(:admin)}	

  scenario "Admin User Click Create Franchise", js: true do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchises_path
    click_button "Create Franchise"
    expect(page).to have_field("franchise_lastname")
  end

  scenario "Admin User Can Create New Franchise", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchises_path
    click_button "Create Franchise"
    #Fill in the franchise file
    select("Southeast", from: "Region")
    fill_in 'Franchise', with: "001"
    fill_in 'Office', with:  "01"
    fill_in "Firm ID", with: "123456"
    fill_in "Last Name", with: "Grenier"
    fill_in "First Name", with: "Daniel"
    fill_in "franchise_address", with: "1234 some street"
    fill_in "franchise_city", with: "Athens"
    fill_in "franchise_state", with: "GA"
    fill_in "franchise_zip_code", with: "30606"
    fill_in "Phone", with: "1234567890"
    fill_in "Email", with: "user@example.com"
    fill_in "Start Date", with: "01/01/2000"
    click_button "Save Changes"
    expect(page).to have_content("Grenier")
  end


end
