require "rails_helper"
require "savon/mock/spec_helper"

RSpec.describe "Interactor - UpdateBankAccount", :type => :interactor do 
	include Savon::SpecHelper

	before(:all) {savon.mock!}
	after(:all) {savon.unmock!}
	let!(:fran) {create :franchise}
	let!(:user) {create(:user)}
	let!(:bank_account) {create :bank_account}
	let!(:params) {attributes_for(:bank_account_create)}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should update bank account" do 
				system_check_return = File.read("spec/factories/gulf/system_check.xml")
			  savon.expects(:system_check).with(message: :any).returns(system_check_return)
			  token_input_return = File.read("spec/factories/gulf/token_input.xml")
	  	  savon.expects(:token_input).with(message: :any).returns(token_input_return)

				interactor = UpdateBankAccount.call(account: bank_account,params: params.merge(franchise: fran), user: user)
				expect(interactor).to be_a_success
				expect(interactor.bank_account.last_four).to eq("6789")
			end
		end

		context "When given invalid attributes" do 
			it "should not update bank_account" do 
				interactor = UpdateBankAccount.call(account: bank_account, params: params.merge(routing: '123456789'), user: user)
				expect(interactor).to be_a_failure
			end
		end
	end
end