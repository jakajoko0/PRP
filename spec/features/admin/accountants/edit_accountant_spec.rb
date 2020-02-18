require 'rails_helper'

RSpec.feature "Editing Accountants", :type => :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  let!(:accountants) {create_list(:accountant,10, franchise: franchise)}
  

  scenario "Admin User Can edit one specific accountant" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_accountants_path
    within("table#accountant-list") do
      first(".edit-link").click
    end
    
    expect(page).to have_field("accountant_lastname", with: accountants.first.lastname)
    expect(page).to_not have_field("accountant_firstname", with: accountants.last.firstname)
  end

  scenario "Admin User Can change data of one specific accountant", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_accountants_path
    within("table#accountant-list") do
      first(".edit-link").click
    end

    expect(page).to have_field("accountant_lastname", with: accountants.first.lastname)
    expect(page).to have_button("Save Changes")
    fill_in 'accountant_lastname', with: "NewValue"
    find('input[name="submit"]').click
    expect(page).to have_content("NewValue")
  end


end
