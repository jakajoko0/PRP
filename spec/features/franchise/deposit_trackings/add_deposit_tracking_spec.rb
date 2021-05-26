require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Adding Deposit", type: :feature do 

  let!(:franchise) {create(:franchise)}
  let!(:user) {create(:user, franchise: franchise)}
	
  scenario "User can Create a Valid Deposit", js: true do 
    visit '/'	
    simulate_user_sign_in(user)
    visit deposit_trackings_path
    click_button("Add Deposit")
    expect(page).to have_content("New Deposit")
    
    fill_in "Total Deposit", with: "12000.00"
    fill_in "Accounting", with: "2000.00"
    fill_in "Backwork", with: "1000.00"
    fill_in "Consulting", with: "2000.00"
    fill_in "Other 1", with: "1000.00"
    fill_in "Other 2", with: "2000.00"
    fill_in "Payroll", with: "1000.00"
    fill_in "Setup", with: "2000.00"
    fill_in "Tax Prep", with: "1000.00"

    click_button "Save"
    

    expect(get_table_cell_text('deposits-list',1,2)).to eq(number_to_currency(2000, precision: 2))
    expect(get_table_cell_text('deposits-list',1,3)).to eq(number_to_currency(1000, precision: 2))
    expect(get_table_cell_text('deposits-list',1,4)).to eq(number_to_currency(2000, precision: 2))
    expect(get_table_cell_text('deposits-list',1,5)).to eq(number_to_currency(1000, precision: 2))
    expect(get_table_cell_text('deposits-list',1,6)).to eq(number_to_currency(2000, precision: 2))
    expect(get_table_cell_text('deposits-list',1,7)).to eq(number_to_currency(1000, precision: 2))
    expect(get_table_cell_text('deposits-list',1,8)).to eq(number_to_currency(1000, precision: 2))
    expect(get_table_cell_text('deposits-list',1,9)).to eq(number_to_currency(2000, precision: 2))
  end

  scenario "User cannot Create an Invalid Deposit", js: true do
    visit '/' 
    simulate_user_sign_in(user)
    visit deposit_trackings_path
    click_button("Add Deposit")
    expect(page).to have_content("New Deposit")
    
    fill_in "Total Deposit", with: "10000.00"
    fill_in "Accounting", with: "2000.00"
    fill_in "Backwork", with: "1000.00"
    fill_in "Consulting", with: "2000.00"
    fill_in "Other 1", with: "1000.00"
    fill_in "Other 2", with: "2000.00"
    fill_in "Payroll", with: "1000.00"
    fill_in "Setup", with: "2000.00"
    fill_in "Tax Prep", with: "1000.00"

    click_button "Save"
         
    expect(page).to have_selector(:id, 'error_explanation')
    page.find("#deposit_tracking_total_deposit")[:class].include?('is-invalid')
  end
end