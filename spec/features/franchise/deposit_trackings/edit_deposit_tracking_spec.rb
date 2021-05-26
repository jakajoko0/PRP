require "rails_helper"
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Editing Financial", type: :feature do 
	let!(:franchise) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise)}
	let!(:deposit) {create(:deposit_tracking, franchise: franchise)}
	
	scenario "Franchise User Can Edit One Specific Deposit", js: true do 

    visit '/'
    simulate_user_sign_in(user)
    visit deposit_trackings_path
    
    within("table#deposits-list") do 
    	first(".edit-link").click
    end

    expect(page).to have_field("Accounting", with: "1000.00")
    expect(page).to have_field("Payroll", with: "2000.00")

    fill_in('Accounting', with: '5000.00')
    fill_in('Payroll', with: '5000.00')
    fill_in('Total Deposit', with: '21000.00')
    
    find('input[name="submit"]').click

    expect(get_table_cell_text('deposits-list',1,2)).to eq(number_to_currency(5000, precision: 2))
    expect(get_table_cell_text('deposits-list',1,5)).to eq(number_to_currency(5000, precision: 2))
    
	
	end

scenario "Franchise User Cannot Modify With Invalid Data", js: true do 

	visit '/'
  simulate_user_sign_in(user)
  visit deposit_trackings_path
    
  within("table#deposits-list") do 
  	first(".edit-link").click
  end

  expect(page).to have_field("Accounting", with: "1000.00")
  expect(page).to have_field("Payroll", with: "2000.00")

  fill_in('Accounting', with: '-10000.00')
  
  find('input[name="submit"]').click

  expect(page).to have_selector(:id, 'error_explanation')
  page.find("#deposit_tracking_accounting")[:class].include?("is-invalid")

end

end