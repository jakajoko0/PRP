require "rails_helper"
require "savon/mock/spec_helper"

RSpec.describe "Interactor - UpdateCreditCard", :type => :interactor do 
	include Savon::SpecHelper

	before(:all) {savon.mock!}
	after(:all) {savon.unmock!}
	let!(:fran) {create :franchise}
	let!(:user) {create(:user)}
	let!(:credit_card) {create :credit_card}
	let!(:params) {attributes_for(:credit_card_create).merge}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should update credit card" do 
				system_check_return = File.read("spec/factories/gulf/system_check.xml")
			  savon.expects(:system_check).with(message: :any).returns(system_check_return)
			  token_input_return = File.read("spec/factories/gulf/token_input_cc.xml")
	  	  savon.expects(:token_input).with(message: :any).returns(token_input_return)

				interactor = UpdateCreditCard.call(account: credit_card,params: params.merge(franchise: fran), user: user)
				expect(interactor).to be_a_success
				expect(interactor.credit_card.last_four).to eq("1111")
			end
		end

		context "When given invalid attributes" do 
			it "should not update credit_card" do 
				interactor = UpdateCreditCard.call(account: credit_card, params: params.merge(cc_number: nil), user: user)
				expect(interactor).to be_a_failure
			end
		end
	end
end