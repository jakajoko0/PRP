require "rails_helper"
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Editing Invoice", type: :feature do 
	let!(:admin) {create(:admin)}
  data = [{firstname: "Daniel", lastname: "Grenier"},{firstname: "Daniel", lastname: "Grenon"}, {firstname: "Daniel", lastname: "Grennier"} ]
  let!(:franchises) {data.map {|d| create(:franchise, d)}}
  let!(:trans_codes) {create_list(:transaction_code, 10, :charge)}
	let!(:invoices) {franchises.map {|f| create(:invoice,  franchise_id: f.id )}}
  let!(:invoices_item) {invoices.map {|i| create(:invoice_item,  invoice_id: i.id )}}
	
	scenario "ADmin User Can Edit One Specific Invoice", js: true do 

    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_invoices_path
    
    within("table#pending-charges-list") do 
    	first(".edit-link").click
    end

    expect(page).to have_field("Description", with: invoices.last.note)
    fill_in('Description', with: 'New Description')
    fill_in "invoice_invoice_items_attributes_0_amount", with: "999.99"
    click_button "Save"
    
    expect(get_table_cell_text('pending-charges-list',3,3)).to eq("New Description")
    expect(get_table_cell_text('pending-charges-list',3,4)).to eq(number_to_currency(999.99, precision:2))
	
	end

scenario "Admin User Cannot Save With Invalid Data", js: true do 

	visit '/'
  simulate_admin_sign_in(admin)
  visit admins_invoices_path
    
  within("table#pending-charges-list") do 
  	first(".edit-link").click
  end

  expect(page).to have_field("Description", with: invoices.last.note)
  fill_in('Description', with: '')
  
  click_button "Save"

  expect(page).to have_selector(:id, 'error_explanation')
  page.find("#invoice_note")[:class].include?("is-invalid")

end

end