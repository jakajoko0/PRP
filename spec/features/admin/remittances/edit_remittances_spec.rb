require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Editing Remittance", :type => :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  let!(:credit_code) {create(:transaction_code, :credit, description: "Acquisition Credit",show_in_royalties: true)}
  let!(:remittance) {create(:remittance, :pending, 
                            franchise: franchise,
                            accounting: 1000.00,
                            backwork: 1000.00,
                            consulting: 1000.00,
                            excluded: 0,
                            other1: 0,
                            other2: 0,
                            payroll: 0,
                            setup: 1000,
                            tax_preparation: 1000.00,
                            calculated_royalty: 450.00,
                            royalty: 450.00,
                            credit1: credit_code.code ,
                            credit1_amount: 100.00,
                            total_due: 350.00 )}

  

  scenario "Admin User Can edit Remittance" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_remittances_path
    within("table#pending-remittances-list") do
      first(".edit-link").click
    end
    
    expect(page).to have_field("remittance_year", with: remittance.year)
  end

  scenario "Admin User Can change data of one specific remittance", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_remittances_path
    within("table#pending-remittances-list") do
      first(".edit-link").click
    end

    expect(page).to have_field("remittance_year", with: remittance.year)
    expect(page).to have_field("remittance_accounting", with: "1000.00")
    fill_in 'Accounting', with: 6000
    page.execute_script("$('#remittance_minimum_royalty').focus()")

    #Make sure form calculates royalty properly
    expect(page).to have_field("remittance_total_collect", disabled: true, with: "10000.00")
    expect(page).to have_field("remittance_calculated_royalty", with: "900.00")
    expect(page).to have_field("remittance_total_due", with: "800.00")

    click_button "Save for Later"

    expect(get_table_cell_text("pending-remittances-list",1,1)).to eq(franchise.number_and_name)
    expect(get_table_cell_text("pending-remittances-list",1,4)).to eq(number_to_currency(10000, precision: 2))
    expect(get_table_cell_text("pending-remittances-list",1,5)).to eq(number_to_currency(900, precision: 2))
    expect(get_table_cell_text("pending-remittances-list",1,6)).to eq(number_to_currency(100, precision: 2))
    expect(get_table_cell_text("pending-remittances-list",1,7)).to eq(number_to_currency(800, precision: 2))



  end

  scenario "Admin User Can change data of one specific remittance and post", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_remittances_path
    within("table#pending-remittances-list") do
      first(".edit-link").click
    end

    expect(page).to have_field("remittance_year", with: remittance.year)
    expect(page).to have_field("remittance_accounting", with: "1000.00")
    fill_in "remittance_date_posted", with: Date.today.strftime("%m/%d/%Y")
    fill_in 'Accounting', with: 6000
    page.execute_script("$('#remittance_minimum_royalty').focus()")

    #Make sure form calculates royalty properly
    expect(page).to have_field("remittance_total_collect", disabled: true, with: "10000.00")
    expect(page).to have_field("remittance_calculated_royalty", with: "900.00")
    expect(page).to have_field("remittance_total_due", with: "800.00")

    
    expect(page).to have_field("remittance_total_due", with: "800.00")
    check "remittance_confirmation"
    click_button "Save and Post"
    
    expect(get_table_cell_text("posted-remittances-list",1,1)).to eq(franchise.number_and_name)
    expect(get_table_cell_text("posted-remittances-list",1,5)).to eq(number_to_currency(10000, precision: 2))
    expect(get_table_cell_text("posted-remittances-list",1,6)).to eq(number_to_currency(900, precision: 2))
    expect(get_table_cell_text("posted-remittances-list",1,7)).to eq(number_to_currency(100, precision: 2))
    expect(get_table_cell_text("posted-remittances-list",1,8)).to eq(number_to_currency(800, precision: 2))

  end


end
