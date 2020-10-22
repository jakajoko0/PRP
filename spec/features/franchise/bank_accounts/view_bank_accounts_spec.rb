require "rails_helper"
require 'savon/mock/spec_helper'

RSpec.feature "Feature - Viewing Bank Accounts", type: :feature do 
	include Savon::SpecHelper
	let!(:franchise1) {create(:franchise)}
	let!(:franchise2) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise1)}
	let!(:bank_account1) {create(:bank_account, franchise: franchise1)}
	let!(:bank_account2) {create(:bank_account, franchise: franchise2)}
	let!(:sys_check) {File.read("spec/factories/gulf/system_check.xml")}
  let!(:token_out) {File.read("spec/factories/gulf/token_output.xml")}
	
	scenario "Franchise User Can View His Bank Accounts List" do
		visit '/'
		simulate_user_sign_in(user)
		visit bank_accounts_path
		expect(page).to have_content(bank_account1.last_four)
		expect(page).to_not have_content(bank_account2.last_four)
	end

	scenario "Franchise User Can View One Specific Account Detail" do 
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

    savon.unmock!
	
	end
end