require "rails_helper"
require 'savon/mock/spec_helper'

RSpec.feature "Feature - Editing Credit Card", type: :feature do 
	include Savon::SpecHelper
	let!(:franchise) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise)}
	let!(:credit_card) {create(:credit_card, franchise: franchise)}
	let!(:sys_check) {File.read("spec/factories/gulf/system_check.xml")}
  let!(:token_in) {File.read("spec/factories/gulf/token_input_different_cc.xml")}
  let!(:token_out) {File.read("spec/factories/gulf/token_output_cc.xml")}
	
	scenario "Franchise User Can Edit One Specific Credit Card", js: true do 
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
    expect(page).to have_field("Address", with: data_hash["op_address"])


    fill_in('Card Number', with: '4012888888881881')

    savon.expects(:system_check).with(message: :any).returns(sys_check)
    savon.expects(:token_input).with(message: :any).returns(token_in)
    
    find('input[name="submit"]').click

    expect(page).to have_content("1881")
       
    savon.unmock!
	
	end

scenario "Franchise User Cannot Save With Bad Card Number", js: true do 
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
  expect(page).to have_field("Address", with: data_hash["op_address"])

  fill_in('Card Number', with: '12345')

  find('input[name="submit"]').click

  expect(page).to have_selector(:id, 'error_explanation')
  page.find("#credit_card_cc_number")[:class].include?("is-invalid")

  savon.unmock!
  


end



end