require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Adding Invoice", type: :feature do 

  let!(:franchise) {create(:franchise)}
  let!(:user) {create(:user, franchise: franchise)}
  let!(:trans_codes) {create_list(:transaction_code, 10, :charge)}
	
  scenario "User can Create a Valid Invoice", js: true do 
    visit '/'	
    simulate_user_sign_in(user)
    visit invoices_path
    click_button("Add Invoice")
    expect(page).to have_content("New Charge")
    
    fill_in "Description", with: "My Invoice Description"
    select(trans_codes[1].description, from: 'invoice_invoice_items_attributes_0_code')
    fill_in "invoice_invoice_items_attributes_0_amount", with: "100.00"
    
    click_button "Save"
    
    expect(get_table_cell_text('pending-charges-list',1,2)).to eq("My Invoice Description")
    expect(get_table_cell_text('pending-charges-list',1,3)).to eq(number_to_currency(100, precision:2))
  end

  scenario "User cannot Create an Invalid Invoice", js: true do
    visit '/' 
    simulate_user_sign_in(user)
    visit invoices_path
    click_button("Add Invoice")
    expect(page).to have_content("New Charge")
    
    select(trans_codes[1].description, from: 'invoice_invoice_items_attributes_0_code')
    fill_in "invoice_invoice_items_attributes_0_amount", with: "100.00"
    
    click_button "Save"
          
    expect(page).to have_selector(:id, 'error_explanation')
    page.find("#invoice_note")[:class].include?('is-invalid')
  end
end