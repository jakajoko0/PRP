require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Adding Financial", type: :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  let!(:franchise2) {create(:franchise)}

  scenario "Admin User Click Add Financial", js: true do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchises_select_index_path(destination: 'add_financial')
    within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("financial_year")
  end

  scenario "Admin User Can Add New Financial", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchises_select_index_path(destination: 'add_financial')
    within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("financial_year")
    expect(page).to have_content("New Financial Report")
    
    fill_in "Year", with: "2020"
    fill_in "Accounting Monthly", with: "1000.00"
    fill_in "Setup", with: "1000.00"
    fill_in "Backwork", with: "1000.00"
    fill_in "Tax Preparation", with: "1000.00"
    fill_in "financial_payroll_processing", with: "1000.00"
    fill_in "Consulting", with: "1000.00"

    fill_in "Supplies", with: "4000.00"
    fill_in "Royalties", with: "4000.00"

    fill_in "Monthly Clients", with: "20"
    fill_in "Quarterly Clients", with: "10"
    fill_in "Total Monthly Fees", with: "10000.00"
    fill_in "financial_total_quarterly_fees", with: "20000.00"

    click_button "Save"
    
    
    expect(get_table_cell_text("financial-list",1,1)).to eq(franchise.number_and_name)
    expect(get_table_cell_text("financial-list",1,4)).to eq(number_to_currency(6000, precision: 2))
    expect(get_table_cell_text('financial-list',1,5)).to eq(number_to_currency(8000, precision: 2))
    expect(get_table_cell_text("financial-list",1,6)).to eq("20")
    expect(get_table_cell_text('financial-list',1,7)).to eq(number_to_currency(10000, precision: 2))
    expect(get_table_cell_text('financial-list',1,8)).to eq("10")
    expect(get_table_cell_text('financial-list',1,9)).to eq(number_to_currency(20000, precision: 2))
  end


end
