require "rails_helper"
require "savon/mock/spec_helper"

RSpec.describe "Interactor - RetrieveBankAccount", :type => :interactor do 
	include Savon::SpecHelper

	before(:all) {savon.mock!}
	after(:all) {savon.unmock!}
	let!(:fran) {create :franchise}
	let!(:user) {create(:user)}
	let!(:current_account) {create :bank_account, account_number: "123456789", bank_token: "26397A74-D387-41C3-803F-F926EEBE9574", routing: "061119888", name_on_account: "FirstName LastName" }

	describe ".call" do 
		context "When given valid attributes" do 
			it "should retrieve bank account" do 
				system_check_return = File.read("spec/factories/gulf/system_check.xml")
			  savon.expects(:system_check).with(message: :any).returns(system_check_return)
			  token_output_return = File.read("spec/factories/gulf/token_output.xml")
	  	  savon.expects(:token_output).with(message: {'token' => current_account.bank_token}).returns(token_output_return)

				interactor = RetrieveBankAccount.call(account: current_account,  user: user)
				current_account.account_number = ""
				expect(interactor).to be_a_success
				expect(interactor.bank_account).to eq(current_account)
			end
		end

		context "When given invalid attributes" do 
			it "should not retrieve bank_account" do 
				system_check_return = File.read("spec/factories/gulf/system_check.xml")
			  savon.expects(:system_check).with(message: :any).returns(system_check_return)
			  token_output_error = File.read("spec/factories/gulf/token_output_error.xml")
	  	  savon.expects(:token_output).with(message: {'token' => 'AAABC'}).returns(token_output_error)
	  	  current_account.bank_token = 'AAABC'
				interactor = RetrieveBankAccount.call(account: current_account, user: user)
				expect(interactor).to be_a_failure
			end
		end
	end
end