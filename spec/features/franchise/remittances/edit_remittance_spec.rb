require "rails_helper"
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Editing Remittance", type: :feature do 
	let!(:franchise) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise)}
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
                            setup: 1000.00,
                            tax_preparation: 1000.00,
                            calculated_royalty: 450.00,
                            royalty: 450.00,
                            credit1: credit_code.code ,
                            credit1_amount: 100.00,
                            total_due: 350.00 )}

	
	scenario "Franchise User Can Edit One Specific Remittance", js: true do 
    visit '/'
    simulate_user_sign_in(user)
    visit remittances_path
    
    within("table#pending-remittances-list") do 
    	first(".edit-link").click
    end

    expect(page).to have_field("Accounting", with: "1000.00")
    fill_in('Accounting', with: 6000)

    page.execute_script("$('#remittance_minimum_royalty').focus()")

    #Make sure form calculates royalty properly
    expect(page).to have_field("remittance_total_collect", disabled: true, with: "10000.00")
    expect(page).to have_field("remittance_calculated_royalty", with: "900.00")
    expect(page).to have_field("remittance_total_due", with: "800.00")
    
    click_button "Save for Later"

    
    expect(get_table_cell_text("pending-remittances-list",1,3)).to eq(number_to_currency(10000, precision: 2))
    expect(get_table_cell_text("pending-remittances-list",1,4)).to eq(number_to_currency(900, precision: 2))
    expect(get_table_cell_text("pending-remittances-list",1,5)).to eq(number_to_currency(100, precision: 2))
    expect(get_table_cell_text("pending-remittances-list",1,6)).to eq(number_to_currency(800, precision: 2))
	
	end

  scenario "Franchise User Can Edit One Specific Remittance and Post it", js: true do 
    visit '/'
    simulate_user_sign_in(user)
    visit remittances_path
    
    within("table#pending-remittances-list") do 
      first(".edit-link").click
    end

    expect(page).to have_field("Accounting", with: "1000.00")
    fill_in('Accounting', with: 6000)

    page.execute_script("$('#remittance_minimum_royalty').focus()")

    #Make sure form calculates royalty properly
    expect(page).to have_field("remittance_total_collect", disabled: true, with: "10000.00")
    expect(page).to have_field("remittance_calculated_royalty", with: "900.00")
    expect(page).to have_field("remittance_total_due", with: "800.00")
    check "remittance_confirmation"
    
    click_button "Save and Post"

    expect(get_table_cell_text("posted-remittances-list",1,4)).to eq(number_to_currency(10000, precision: 2))
    expect(get_table_cell_text("posted-remittances-list",1,5)).to eq(number_to_currency(900, precision: 2))
    expect(get_table_cell_text("posted-remittances-list",1,6)).to eq(number_to_currency(100, precision: 2))
    expect(get_table_cell_text("posted-remittances-list",1,7)).to eq(number_to_currency(800, precision: 2))
  
  end

  scenario "Franchise User Cannot Save Invalid Remittance", js: true do 

	  visit '/'
    simulate_user_sign_in(user)
    visit remittances_path
    
    within("table#pending-remittances-list") do 
  	  first(".edit-link").click
    end

    expect(page).to have_field("Accounting", with: "1000.00")
    
    fill_in('Accounting', with: 6000)
    
    click_button "Save and Post"

    expect(page).to have_selector(:id, 'error_explanation')
    
  
  end

end