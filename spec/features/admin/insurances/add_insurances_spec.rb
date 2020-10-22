require 'rails_helper'

RSpec.feature "Feature - Adding Insurance", :type => :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}

  scenario "Admin User Click Add Insurance", js: true do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_insurances_path
    click_button "Add Insurance"
     within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("insurance_eo_insurance")
  end

  scenario "Admin User Can Add New Insurance", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_insurances_path
    click_button "Add Insurance"
    within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("insurance_eo_insurance")
    #Fill in the franchise file
    check "insurance_eo_insurance"
    fill_in "insurance_eo_expiration", with: "01/01/2000"
    click_button "Save Changes"
    expect(page).to have_content(franchise.lastname)
    expect(page).to have_content(franchise.firstname)
  end

end
