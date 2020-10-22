require "rails_helper"
require "savon/mock/spec_helper"

RSpec.describe "Interactor - RetrieveCreditCard", :type => :interactor do 
	include Savon::SpecHelper

	before(:all) {savon.mock!}
	after(:all) {savon.unmock!}
	let!(:fran) {create :franchise}
	let!(:user) {create(:user)}
	let!(:current_card) {create :credit_card, cc_number: "4111111111111111", 
		                   card_token: "26397A74-D387-41C3-803F-F926EEBE9574",
		                   cc_type: "V", cc_exp_year: "25", cc_exp_month: "01",
		                   cc_name: "FirstName LastName", cc_address: "1234 Some Street",
		                   cc_city: "Athens", cc_state: "GA", cc_zip: "30606"   }

	describe ".call" do 
		context "When given valid attributes" do 
			it "should retrieve credit card" do 
				system_check_return = File.read("spec/factories/gulf/system_check.xml")
			  savon.expects(:system_check).with(message: :any).returns(system_check_return)
			  token_output_return = File.read("spec/factories/gulf/token_output_cc.xml")
	  	  savon.expects(:token_output).with(message: {'token' => current_card.card_token}).returns(token_output_return)

				interactor = RetrieveCreditCard.call(account: current_card,  user: user)
				current_card.cc_number = ""
				expect(interactor).to be_a_success
				expect(interactor.credit_card).to eq(current_card)
			end
		end

		context "When given invalid attributes" do 
			it "should not retrieve credit card" do 
				system_check_return = File.read("spec/factories/gulf/system_check.xml")
			  savon.expects(:system_check).with(message: :any).returns(system_check_return)
			  token_output_error = File.read("spec/factories/gulf/token_output_error.xml")
	  	  savon.expects(:token_output).with(message: {'token' => 'AAABC'}).returns(token_output_error)
	  	  current_card.card_token = 'AAABC'
				interactor = RetrieveCreditCard.call(account: current_card, user: user)
				expect(interactor).to be_a_failure
			end
		end
	end
end