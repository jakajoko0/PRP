require 'rails_helper'
require 'savon/mock/spec_helper'

RSpec.feature "Feature - Adding Credit Card", type: :feature do 
  include Savon::SpecHelper
  let!(:franchise) {create(:franchise)}
  let!(:user) {create(:user, franchise: franchise)}
  let!(:sys_check) {File.read("spec/factories/gulf/system_check.xml")}
  let!(:token_in) {File.read("spec/factories/gulf/token_input_cc.xml")}
	
  scenario "User can Create a Valid Credit Card", js: true do 
    savon.mock!
    savon.expects(:system_check).with(message: :any).returns(sys_check)
    savon.expects(:token_input).with(message: :any).returns(token_in)

    visit '/'	
    simulate_user_sign_in(user)
    visit credit_cards_path
    click_button("Add Credit Card")
    expect(page).to have_content("Add New Credit Card")
    select("Visa", from: "Card Type")
    fill_in "Name on Card", with: "FirstName LastName"
    fill_in "Card Number", with: "4111111111111111"
    select("01", from: "credit_card_cc_exp_month")
    select("25", from: "credit_card_cc_exp_year")
    fill_in "Address", with: "1234 Some Street"
    fill_in "City", with: "Athens"
    fill_in "State", with: "GA"
    fill_in "Zip Code", with: "30606"
    click_button "Save"
    
    expect(get_table_cell_text('credit-card-list',1,2)).to eq("1111")
    expect(get_table_cell_text('credit-card-list',1,3)).to eq("1 / 25")
    savon.unmock!
  end

  scenario "User cannot Create an Invalid Credit Card", js: true do 
    visit '/'	
    simulate_user_sign_in(user)
    visit credit_cards_path
    click_button("Add Credit Card")
    expect(page).to have_content("Add New Credit Card")
    select("V", from: "Card Type")
    fill_in "Name on Card", with: "FirstName LastName"
    fill_in "Card Number", with: "4111"
    select("01", from: "credit_card_cc_exp_month")
    select("25", from: "credit_card_cc_exp_year")
    fill_in "Address", with: "1234 Some Street"
    fill_in "City", with: "Athens"
    fill_in "State", with: "GA"
    fill_in "Zip Code", with: "30606"
    click_button "Save"
    
    expect(page).to have_selector(:id, 'error_explanation')
    page.find("#credit_card_cc_number")[:class].include?('is-invalid')
  end
end