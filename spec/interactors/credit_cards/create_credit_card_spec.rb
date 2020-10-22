require "rails_helper"
require "savon/mock/spec_helper"

RSpec.describe "Interactor - CreateCreditCard", :type => :interactor do 
	include Savon::SpecHelper

	before(:all) {savon.mock!}
	after(:all) {savon.unmock!}
	let!(:fran) {create :franchise}
	let!(:user) {create(:user)}
	let!(:params) {attributes_for(:credit_card_create)}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should create credit card" do 
				system_check_return = File.read("spec/factories/gulf/system_check.xml")
			  savon.expects(:system_check).with(message: :any).returns(system_check_return)
			  token_input_return = File.read("spec/factories/gulf/token_input_cc.xml")
	  	  savon.expects(:token_input).with(message: {'token' => nil, 'token_type' => params[:cc_type],'expiration_month' => params[:cc_exp_month],'expiration_year' => params[:cc_exp_year],'name' => params[:cc_name], 'acct_cc_number' => params[:cc_number], 'address' => params[:cc_address], 'city' => params[:cc_city], 'state' => params[:cc_state], 'zip' => params[:cc_zip]}).returns(token_input_return)

				interactor = CreateCreditCard.call(params: params.merge(franchise: fran), user: user)
				expect(interactor).to be_a_success
				expect(interactor.credit_card).to eq(CreditCard.last)
			end
		end

		context "When given invalid attributes" do 
			it "should not create credit card" do 
				interactor = CreateCreditCard.call(params: params.merge(cc_type: nil), user: user)
				expect(interactor).to be_a_failure
			end
		end
	end
end