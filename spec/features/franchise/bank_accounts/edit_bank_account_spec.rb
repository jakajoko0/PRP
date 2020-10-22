require "rails_helper"
require 'savon/mock/spec_helper'

RSpec.feature "Feature - Editing Bank Accounts", type: :feature do 
	include Savon::SpecHelper
	let!(:franchise) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise)}
	let!(:bank_account) {create(:bank_account, franchise: franchise)}
	let!(:sys_check) {File.read("spec/factories/gulf/system_check.xml")}
  let!(:token_in) {File.read("spec/factories/gulf/token_input.xml")}
  let!(:token_out) {File.read("spec/factories/gulf/token_output.xml")}
	
	scenario "Franchise User Can Edit One Specific Bank Account", js: true do 
	  savon.mock!
	  
	  savon.expects(:system_check).with(message: :any).returns(sys_check)
    savon.expects(:token_output).with(message: :any).returns(token_out)

    visit '/'
    simulate_user_sign_in(user)
    visit bank_accounts_path
    
    within("table#bank-account-list") do 
    	first(".edit-link").click
    end

    returned_xml = Hash.from_xml(token_out)
    data_hash = returned_xml.dig("Envelope","Body","TokenOutputResponse", "TokenOutputResult")

    expect(page).to have_field("Routing", with: data_hash["ach_routing"])
    expect(page).to have_field("Owner Name", with: data_hash["req_record_name"])

    fill_in('Account Number', with: '123456789')

    savon.expects(:system_check).with(message: :any).returns(sys_check)
    savon.expects(:token_input).with(message: :any).returns(token_in)
    
    find('input[name="submit"]').click

    expect(page).to have_content("6789")
       
    savon.unmock!
	
	end

scenario "Franchise User Cannot Save With Bad routing", js: true do 
	savon.mock!

  savon.expects(:system_check).with(message: :any).returns(sys_check)
  savon.expects(:token_output).with(message: :any).returns(token_out)

	visit '/'
  simulate_user_sign_in(user)
  visit bank_accounts_path
    
  within("table#bank-account-list") do 
  	first(".edit-link").click
  end

  returned_xml = Hash.from_xml(token_out)
  data_hash = returned_xml.dig("Envelope","Body","TokenOutputResponse", "TokenOutputResult")

  expect(page).to have_field("Routing", with: data_hash["ach_routing"])
  expect(page).to have_field("Owner Name", with: data_hash["req_record_name"])

  fill_in('Routing', with: '123456789')
  fill_in('Account Number', with: '1234567')

  find('input[name="submit"]').click

  expect(page).to have_selector(:id, 'error_explanation')
  page.find("#bank_account_routing")[:class].include?("is-invalid")

  savon.unmock!
  


end



end