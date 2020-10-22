require 'rails_helper'
require 'savon/mock/spec_helper'

RSpec.feature "Feature - Adding Bank Account", type: :feature do 
  include Savon::SpecHelper
  let!(:franchise) {create(:franchise)}
  let!(:user) {create(:user, franchise: franchise)}
  let!(:sys_check) {File.read("spec/factories/gulf/system_check.xml")}
  let!(:token_in) {File.read("spec/factories/gulf/token_input.xml")}
	
  scenario "User can Create a Valid Bank Account", js: true do 
    savon.mock!
    savon.expects(:system_check).with(message: :any).returns(sys_check)
    savon.expects(:token_input).with(message: :any).returns(token_in)

    visit '/'	
    simulate_user_sign_in(user)
    visit bank_accounts_path
    click_button("Add Bank Account")
    expect(page).to have_content("Add New Bank Account")
    select("Checking", from: "Account Type")
    fill_in "Routing", with: "061119888"
    fill_in "Account Number", with: "123456789"
    fill_in "Bank Name", with: "STATE BANK AND TRUST"
    fill_in "Owner Name", with: "FirstName LastName"
    click_button "Save"
    
    expect(get_table_cell_text('bank-account-list',1,2)).to eq("Checking")
    expect(get_table_cell_text('bank-account-list',1,3)).to eq("6789")
    savon.unmock!
  end

  scenario "User cannot Create an Invalid Bank Account", js: true do 
    visit '/'	
    simulate_user_sign_in(user)
    visit bank_accounts_path
    click_button("Add Bank Account")
    expect(page).to have_content("Add New Bank Account")
    select("Checking", from: "Account Type")
    fill_in "Routing", with: "111111111"
    fill_in "Account Number", with: "123456789"
    fill_in "Bank Name", with: "STATE BANK AND TRUST"
    fill_in "Owner Name", with: "FirstName LastName"

    click_button "Save"
      
    expect(page).to have_selector(:id, 'error_explanation')
    page.find("#bank_account_routing")[:class].include?('is-invalid')
  end
end