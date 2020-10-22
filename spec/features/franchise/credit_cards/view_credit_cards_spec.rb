require "rails_helper"
require 'savon/mock/spec_helper'

RSpec.feature "Feature - Viewing Credit Cards", type: :feature do 
	include Savon::SpecHelper
	let!(:franchise1) {create(:franchise)}
	let!(:franchise2) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise1)}
	let!(:credit_card1) {create(:credit_card, franchise: franchise1)}
	let!(:credit_card2) {create(:credit_card, franchise: franchise2)}
	let!(:sys_check) {File.read("spec/factories/gulf/system_check.xml")}
  let!(:token_out) {File.read("spec/factories/gulf/token_output_cc.xml")}
	
	scenario "Franchise User Can View His Credit Cards List" do
		visit '/'
		simulate_user_sign_in(user)
		visit credit_cards_path
		expect(page).to have_content(credit_card1.last_four)
		expect(page).to_not have_content(credit_card2.last_four)
	end

	
	scenario "Franchise User Can View One Specific Credit Card Detail" do 
	  savon.mock!
	  
	  savon.expects(:system_check).with(message: :any).returns(sys_check)
    savon.expects(:token_output).with(message: :any).returns(token_out)

    visit '/'
    simulate_user_sign_in(user)
    visit credit_cards_path
    within("table#credit-card-list") do 
    	first(".edit-link").click
    end

    returned_xml = Hash.from_xml(token_out)
    data_hash = returned_xml.dig("Envelope","Body","TokenOutputResponse", "TokenOutputResult")

    expect(page).to have_field("Name on Card", with: data_hash["req_record_name"])
    expect(page).to have_field("City", with: data_hash["op_city"])

    savon.unmock!
	
	end
end