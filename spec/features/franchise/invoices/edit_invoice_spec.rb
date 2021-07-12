require "rails_helper"
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Editing Invoice", type: :feature do 
	let!(:franchise) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise)}
  let!(:trans_codes) {create_list(:transaction_code, 10, :charge)}
	let!(:my_invoice) {create(:invoice, franchise: franchise)}
  let!(:my_invoice_item) {create(:invoice_item, invoice: my_invoice)}
	
	scenario "Franchise User Can Edit One Specific Invoice", js: true do 

    visit '/'
    simulate_user_sign_in(user)
    visit invoices_path
    
    within("table#pending-charges-list") do 
    	first(".edit-link").click
    end

    expect(page).to have_field("Description", with: my_invoice.note)
    fill_in('Description', with: 'New Description')
    fill_in "invoice_invoice_items_attributes_0_amount", with: "999.99"
    click_button "Save"

    expect(get_table_cell_text('pending-charges-list',1,2)).to eq("New Description")
    expect(get_table_cell_text('pending-charges-list',1,4)).to eq(number_to_currency(999.99, precision:2))
	
	end

scenario "Franchise User Cannot Save With Invalid Data", js: true do 

	visit '/'
  simulate_user_sign_in(user)
  visit invoices_path
    
  within("table#pending-charges-list") do 
  	first(".edit-link").click
  end

  expect(page).to have_field("Description", with: my_invoice.note)
  fill_in('Description', with: '')
  
  click_button "Save"

  expect(page).to have_selector(:id, 'error_explanation')
  page.find("#invoice_note")[:class].include?("is-invalid")

end

end