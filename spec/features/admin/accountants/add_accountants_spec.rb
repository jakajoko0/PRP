require 'rails_helper'

RSpec.feature "Feature - Adding Accountants", :type => :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchises) {create_list(:franchise, 2)}

  scenario "Admin User Click Create Accountant", js: true do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_accountants_path
    click_button "Add Accountant"
    within("table#franchise-list") do
      first(".btn").click
    end
   
    expect(page).to have_field("accountant_lastname")
  end

  scenario "Admin User Can Create New Accountant", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_accountants_path
    click_button "Add Accountant"
    within("table#franchise-list") do
      first(".btn").click
    end
    #Fill in the accountant file
    fill_in 'Accountant', with: "01"
    fill_in "Last Name", with: "Grenier"
    fill_in "First Name", with: "Daniel"
    fill_in "accountant_birth_date", with: "01/01/1976"
    fill_in "Start Date", with: "01/01/2000"
    click_button "Save Changes"
    expect(page).to have_content("Grenier")
  end


end
