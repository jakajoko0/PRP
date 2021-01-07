require 'rails_helper'

RSpec.feature "Feature - Adding Transaction Code", :type => :feature do 
  let!(:admin) {create(:admin)}	
  
  scenario "Admin User Click Add Transaction Code", js: true do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_transaction_codes_path
    click_button "Add Transaction Code"

    expect(page).to have_field("transaction_code_code")
  end

  scenario "Admin User Can Add New Transaction Code", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_transaction_codes_path
    click_button "Add Transaction Code"
     expect(page).to have_field("transaction_code_code")
    
    fill_in "transaction_code_code", with: "01"
    fill_in "transaction_code_description", with: "Description 01"
    select("Charge", from: "Transaction Type")
    click_button "Save"
    expect(page).to have_content("01")
    expect(page).to have_content("Description 01")
    expect(page).to have_content("Charge")
  end

end
