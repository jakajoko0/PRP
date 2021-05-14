require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Adding Invoice", type: :feature do 
  let!(:admin) {create(:admin)}
  let!(:franchise) {create(:franchise)}
  let!(:franchise2) {create(:franchise)}
  let!(:trans_codes) {create_list(:transaction_code, 10, :charge)}
	
  scenario "Admin can Create a Valid Invoice", js: true do 
    visit '/'	
    simulate_admin_sign_in(admin)
    visit admins_franchises_select_index_path(destination: 'add_invoice')
    within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_content("New Charge")
    
    fill_in "Description", with: "My Invoice Description"
    select(trans_codes[1].description, from: 'invoice_invoice_items_attributes_0_code')
    fill_in "invoice_invoice_items_attributes_0_amount", with: "100.00"
    
    click_button "Save"
    
    expect(get_table_cell_text('pending-charges-list',1,3)).to eq("My Invoice Description")
    expect(get_table_cell_text('pending-charges-list',1,4)).to eq(number_to_currency(100, precision:2))
  end

  scenario "Admin cannot Create an Invalid Invoice", js: true do
    visit '/' 
    simulate_admin_sign_in(admin)
    visit admins_franchises_select_index_path(destination: 'add_invoice')
    within("table#franchise-list") do
      first(".btn").click
    end

    expect(page).to have_content("New Charge")
    
    select(trans_codes[1].description, from: 'invoice_invoice_items_attributes_0_code')
    fill_in "invoice_invoice_items_attributes_0_amount", with: "100.00"
    
    click_button "Save"
          
    expect(page).to have_selector(:id, 'error_explanation')
    page.find("#invoice_note")[:class].include?('is-invalid')
  end
end