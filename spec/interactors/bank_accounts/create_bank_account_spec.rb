require "rails_helper"
require "savon/mock/spec_helper"

RSpec.describe "Interactor - CreateBankAccount", :type => :interactor do 
	include Savon::SpecHelper

	before(:all) {savon.mock!}
	after(:all) {savon.unmock!}
	let!(:fran) {create :franchise}
	let!(:user) {create(:user)}
	let!(:params) {attributes_for(:bank_account_create)}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should create bank account" do 
				system_check_return = File.read("spec/factories/gulf/system_check.xml")
			  savon.expects(:system_check).with(message: :any).returns(system_check_return)
			  token_input_return = File.read("spec/factories/gulf/token_input.xml")
	  	  savon.expects(:token_input).with(message: {'token' => nil, 'token_type' => params[:type_of_account], 'routing' => params[:routing], 'name' => params[:name_on_account], 'acct_cc_number' => params[:account_number]}).returns(token_input_return)

				interactor = CreateBankAccount.call(params: params.merge(franchise: fran), user: user)
				expect(interactor).to be_a_success
				expect(interactor.bank_account).to eq(BankAccount.last)
			end
		end

		context "When given invalid attributes" do 
			it "should not create bank_account" do 
				interactor = CreateBankAccount.call(params: params.merge(routing: '123456789'), user: user)
				expect(interactor).to be_a_failure
			end
		end
	end
end