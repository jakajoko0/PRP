require 'rails_helper'

RSpec.feature "Feature - Editing Credits", type: :feature do
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  let!(:trans_codes) {create_list(:transaction_code, 10, :credit)}
  let!(:credit1) {create(:prp_transaction,:credit, franchise: franchise, trans_code: trans_codes[1].code )}
  let!(:credit2) {create(:prp_transaction, :credit, franchise: franchise, trans_code: trans_codes[2].code )}
  let!(:credit3) {create(:prp_transaction, :credit, franchise: franchise, trans_code: trans_codes[3].code )}
  

  scenario "Admin User Can edit one specific credit" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_credits_path
    within("table#credit-list") do
      first(".edit-link").click
    end
    
    expect(page).to have_field("Description", with: credit3.trans_description)
    expect(page).to_not have_field("prp_transaction_trans_code", with: trans_codes[2].description)
  end

  scenario "Admin User Can change data of one specific credit", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_credits_path
    within("table#credit-list") do
      first(".edit-link").click
    end

    expect(page).to have_field("Description", with: credit3.trans_description)
    expect(page).to have_button("Save")
    fill_in 'Description', with: "NewValue"
    find('input[name="submit"]').click
    expect(page).to have_content("NewValue")
  end


end
