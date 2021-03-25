require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Adding Remittance", type: :feature do 
  let!(:admin) {create(:admin)}	
  let!(:credit_code) {create(:transaction_code, :credit, description: "Acquisition Credit",show_in_royalties: true)}
                                                                       
  let!(:franchise) {create(:franchise)}
  let!(:franchise2) {create(:franchise)}

  scenario "Admin User Click Add Remittance", js: true do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchises_select_index_path(destination: 'add_royalty')
    within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("remittance_year")
  end

  scenario "Admin User Can Add New Pending Remittance", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchises_select_index_path(destination: 'add_royalty')
    within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("remittance_year")
    #Make sure the proper default dates are showing
    expect(page).to have_field("remittance_date_received", with: Date.today.strftime("%m/%d/%Y"))
    expect(page).to have_field("remittance_date_posted", with: Date.today.strftime("%m/%d/%Y"))
    #Fill In some Collections
    #Make sure the report is never late
    fill_in 'Year', with: (Date.today.year)+1
    fill_in 'Accounting', with: 1000
    fill_in 'Backwork', with: 1000
    fill_in 'Consulting', with: 1000
    fill_in 'Payroll', with: 1000
    fill_in 'Tax Preparation', with: 1000
    #Move focus to have the Tax Prep amount added to calc
    page.execute_script("$('#remittance_minimum_royalty').focus()")

    #Make sure form calculates royalty properly
    expect(page).to have_field("remittance_total_collect", disabled: true, with: "5000.00")
    expect(page).to have_field("remittance_calculated_royalty", with: "450.00")
    expect(page).to have_field("remittance_total_due", with: "450.00")

    #Add 1 credit
    select("Acquisition Credit", from: "remittance_credit1")
    
    fill_in 'remittance_credit1_amount', with: 100

    #Move focus to have the credit added to calc
    page.execute_script("$('#remittance_credit2_amount').focus()")

    expect(page).to have_field("remittance_total_due", with: "350.00")

    click_button "Save for Later"
    
    expect(get_table_cell_text("pending-remittances-list",1,1)).to eq(franchise.number_and_name)
    expect(get_table_cell_text("pending-remittances-list",1,4)).to eq(number_to_currency(5000, precision: 2))
    expect(get_table_cell_text("pending-remittances-list",1,5)).to eq(number_to_currency(450, precision: 2))
    expect(get_table_cell_text("pending-remittances-list",1,6)).to eq(number_to_currency(100, precision: 2))
    expect(get_table_cell_text("pending-remittances-list",1,7)).to eq(number_to_currency(350, precision: 2))

  end

  scenario "Admin User Can Add New Posted Remittance", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchises_select_index_path(destination: 'add_royalty')
    within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("remittance_year")
    #Make sure the proper default dates are showing
    expect(page).to have_field("remittance_date_received", with: Date.today.strftime("%m/%d/%Y"))
    expect(page).to have_field("remittance_date_posted", with: Date.today.strftime("%m/%d/%Y"))
    #Fill In some Collections
    fill_in 'Year', with: (Date.today.year)+1
    fill_in 'Accounting', with: 1000
    fill_in 'Backwork', with: 1000
    fill_in 'Consulting', with: 1000
    fill_in 'Payroll', with: 1000
    fill_in 'Tax Preparation', with: 1000
    #Move focus to have the Tax Prep amount added to calc
    page.execute_script("$('#remittance_minimum_royalty').focus()")

    #Make sure form calculates royalty properly
    expect(page).to have_field("remittance_total_collect", disabled: true, with: "5000.00")
    expect(page).to have_field("remittance_calculated_royalty", with: "450.00")
    expect(page).to have_field("remittance_total_due", with: "450.00")

    #Add 1 credit
    select("Acquisition Credit", from: "remittance_credit1")
    
    fill_in 'remittance_credit1_amount', with: 100

    #Move focus to have the credit added to calc
    page.execute_script("$('#remittance_credit2_amount').focus()")

    expect(page).to have_field("remittance_total_due", with: "350.00")

    check "remittance_confirmation"

    click_button "Save and Post"
    
    expect(get_table_cell_text("posted-remittances-list",1,1)).to eq(franchise.number_and_name)
    expect(get_table_cell_text("posted-remittances-list",1,5)).to eq(number_to_currency(5000, precision: 2))
    expect(get_table_cell_text("posted-remittances-list",1,6)).to eq(number_to_currency(450, precision: 2))
    expect(get_table_cell_text("posted-remittances-list",1,7)).to eq(number_to_currency(100, precision: 2))
    expect(get_table_cell_text("posted-remittances-list",1,8)).to eq(number_to_currency(350, precision: 2))

  end

end
