require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Adding Remittance", type: :feature do 

  let!(:franchise) {create(:franchise, :with_min_royalty )}
  let!(:user) {create(:user, franchise: franchise)}
	
  scenario "User can Create a Valid Pending Remittance", js: true do 
    visit '/'	
    simulate_user_sign_in(user)
    visit remittances_path
    click_button("Continue")
    expect(page).to have_content("New Royalty Report")
    expect(page).to have_field("remittance_year")
    expect(page).to_not have_field("remittance_date_received")
    expect(page).to have_field("Minimum Royalty", with: "450.00")
    fill_in 'Year', with: (Date.today.year)+1 
    fill_in "Accounting", with: "1000.00"
    fill_in "Backwork", with: "1000.00"
    fill_in "Consulting", with: "1000.00"
    fill_in "Tax Preparation", with: "1000.00"
    fill_in "Payroll", with: "1000.00"
    fill_in "Setup", with: "1000.00"
    #Move focus to have the Tax Prep amount added to calc
    page.execute_script("$('#remittance_minimum_royalty').focus()")

    #Make sure form calculates royalty properly
    expect(page).to have_field("remittance_total_collect", disabled: true, with: "6000.00")
    expect(page).to have_field("remittance_calculated_royalty", with: "540.00")
    expect(page).to have_field("remittance_total_due", with: "540.00")

    click_button "Save for Later"
    
    expect(get_table_cell_text('pending-remittances-list',1,3)).to eq(number_to_currency(6000, precision: 2))
    expect(get_table_cell_text('pending-remittances-list',1,4)).to eq(number_to_currency(540, precision: 2))
    expect(get_table_cell_text('pending-remittances-list',1,5)).to eq(number_to_currency(0, precision: 2))
    expect(get_table_cell_text('pending-remittances-list',1,6)).to eq(number_to_currency(540, precision: 2))
  end

  scenario "User can Create a Valid Posted Remittance", js: true do 
    visit '/'   
    simulate_user_sign_in(user)
    visit remittances_path
    click_button("Continue")
    expect(page).to have_content("New Royalty Report")
    expect(page).to have_field("remittance_year")
    expect(page).to_not have_field("remittance_date_received")
    fill_in 'Year', with: (Date.today.year)+1
    fill_in "Accounting", with: "1000.00"
    fill_in "Backwork", with: "1000.00"
    fill_in "Consulting", with: "1000.00"
    fill_in "Tax Preparation", with: "1000.00"
    fill_in "Payroll", with: "1000.00"
    fill_in "Setup", with: "1000.00"
    #Move focus to have the Tax Prep amount added to calc
    page.execute_script("$('#remittance_minimum_royalty').focus()")

    #Make sure form calculates royalty properly
    expect(page).to have_field("remittance_total_collect", disabled: true, with: "6000.00")
    expect(page).to have_field("remittance_calculated_royalty", with: "540.00")
    expect(page).to have_field("remittance_total_due", with: "540.00")
    check "remittance_confirmation"
    click_button "Save and Post"
    
    expect(get_table_cell_text('posted-remittances-list',1,4)).to eq(number_to_currency(6000, precision: 2))
    expect(get_table_cell_text('posted-remittances-list',1,5)).to eq(number_to_currency(540, precision: 2))
    expect(get_table_cell_text('posted-remittances-list',1,6)).to eq(number_to_currency(0, precision: 2))
    expect(get_table_cell_text('posted-remittances-list',1,7)).to eq(number_to_currency(540, precision: 2))
  end

  scenario "User cannot Create an Invalid Remittance", js: true do
    visit '/' 
    simulate_user_sign_in(user)
    visit remittances_path
    click_button("Continue")
    expect(page).to have_content("New Royalty Report")
    
    fill_in "Accounting", with: "1000.00"
    fill_in "Setup", with: "1000.00"
    fill_in "Backwork", with: "1000.00"
    #Move focus to have the Tax Prep amount added to calc
    page.execute_script("$('#remittance_minimum_royalty').focus()")
    
    fill_in "Actual Royalty", with: "-1000"

    click_button "Save and Post" 
          
    expect(page).to have_selector(:id, 'error_explanation')
    page.find("#remittance_royalty")[:class].include?('is-invalid')
  end
end