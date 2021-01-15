require 'rails_helper'

RSpec.feature "Feature - Adding Credit", type: :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  let!(:franchise2) {create(:franchise)}
  let!(:trans_codes) {create_list(:transaction_code, 10, :credit)}
  let!(:fran_credit) {create_list(:prp_transaction,5, :credit, franchise: franchise, trans_code: trans_codes[1])}

  scenario "Admin User Click Add Credit", js: true do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_credits_path
    click_button "Add Credit"
     within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("prp_transaction_trans_code")
  end

  scenario "Admin User Can Add New Credit", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_credits_path
    click_button "Add Credit"
    within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("prp_transaction_trans_code")
    fill_in 'Date Posted', with: "01/01/2021"   
    select(trans_codes[1].description, from: 'prp_transaction_trans_code')
    fill_in 'Description', with: 'My New Description'
    fill_in 'Amount', with: 444.00
    click_button "Save"
    expect(page).to have_content(franchise.lastname)
    expect(page).to have_content('My New Description')
    expect(page).to have_content(trans_codes[1].description)
  end

end
