require 'rails_helper'

RSpec.feature "Feature - Editing Transaction Code", :type => :feature do 
  let!(:admin) {create(:admin)}	
  let!(:trans_code) {create(:transaction_code)}


  scenario "Admin User Can edit Transaction Code record" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_transaction_codes_path
    within("table#trans-code-list") do
      first(".edit-link").click
    end
    
    expect(page).to have_field("transaction_code_code", with: trans_code.code)
  end

  scenario "Admin User Can change data of one specific transaction code", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_transaction_codes_path
    within("table#trans-code-list") do
      first(".edit-link").click
    end

    expect(page).to have_field("transaction_code_code", with: trans_code.code)
    expect(page).to have_button("Save")
    fill_in "transaction_code_description", with: "New Description"
    find('input[name="submit"]').click
    expect(page).to have_content("New Description")
  end


end
