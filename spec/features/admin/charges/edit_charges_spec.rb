require 'rails_helper'

RSpec.feature "Feature - Editing Credits", type: :feature do
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  let!(:trans_codes) {create_list(:transaction_code, 10, :charge)}
  let!(:charge1) {create(:prp_transaction,:charge, franchise: franchise, trans_code: trans_codes[1].code )}
  let!(:charge2) {create(:prp_transaction, :charge, franchise: franchise, trans_code: trans_codes[2].code )}
  let!(:charge3) {create(:prp_transaction, :charge, franchise: franchise, trans_code: trans_codes[3].code )}
  

  scenario "Admin User Can edit one specific charge" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_charges_path
    within("table#charge-list") do
      first(".edit-link").click
    end
    
    expect(page).to have_field("Description", with: charge3.trans_description)
    expect(page).to_not have_field("prp_transaction_trans_code", with: trans_codes[2].description)
  end

  scenario "Admin User Can change data of one specific charge", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_charges_path
    within("table#charge-list") do
      first(".edit-link").click
    end

    expect(page).to have_field("Description", with: charge3.trans_description)
    expect(page).to have_button("Save")
    fill_in 'Description', with: "NewValue"
    find('input[name="submit"]').click
    expect(page).to have_content("NewValue")
  end


end
