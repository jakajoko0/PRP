require "rails_helper"

RSpec.describe "Interactor - CreateTransactionCode", :type => :interactor do 
	let!(:admin) {create(:admin)}
	let!(:params) {attributes_for(:transaction_code)}


	describe ".call" do 
		context "When given valid attributes" do 
			it "should create transaction code" do 
				interactor = CreateTransactionCode.call(params: params, user: admin)
				expect(interactor).to be_a_success
				expect(interactor.trans_code).to eq(TransactionCode.last)
			end

		end

		context "When given invalid attributes" do 
			it "should not create transaction code" do 
				interactor = CreateTransactionCode.call(params: params.merge(description: nil), user: admin)
				expect(interactor).to be_a_failure
			end

		end
	end

end