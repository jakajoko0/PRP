require 'rails_helper'

RSpec.feature "Feature - Editing Insurance", :type => :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  let!(:insurance) {create(:insurance, eo_insurance: 1, eo_expiration: '01/01/2000', franchise: franchise)}
  

  scenario "Admin User Can edit insurance record" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_insurances_path
    within("table#insurance-list") do
      first(".edit-link").click
    end
    
    expect(page).to have_field("insurance_eo_insurance", with: insurance.eo_insurance)
    expect(page).to have_field("insurance_eo_expiration")
  end

  scenario "Admin User Can change data of one specific insurance record", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_insurances_path
    within("table#insurance-list") do
      first(".edit-link").click
    end

    expect(page).to have_field("insurance_eo_insurance", with: insurance.eo_insurance)
    expect(page).to have_button("Save Changes")
    check "insurance_gen_insurance"
    fill_in "insurance_gen_expiration", with: "01/01/2001"
    check "insurance_other_insurance"
    fill_in "insurance_other_expiration", with: "01/01/2002"
    fill_in "insurance_other_description", with: "New Description"
    find('input[name="submit"]').click
    expect(page).to have_content("01/01/2001")
    expect(page).to have_content("01/01/2002")
  end


end
