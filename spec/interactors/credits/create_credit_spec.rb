require "rails_helper"

RSpec.describe "Interactor - CreateCredit", type: :interactor do 
	let!(:admin) {create (:admin)}
	let!(:fran) {create :franchise}
	let!(:params) {FactoryBot.attributes_for(:prp_transaction, :credit).merge(date_posted: "01/01/2021", franchise: fran)}

	describe ".call" do 
		context "When given valid attributes" do
		  it "should create the credit" do 
			  interactor = CreateCredit.call(params: params, user: admin)
			  expect(interactor).to be_a_success
			  expect(interactor.credit).to eq(PrpTransaction.last)
			end
		end

		context "When given invalid attributes" do 
			it "should not create the credit" do 
				interactor = CreateCredit.call(params: params.merge(amount: -1.00), user: admin)
				expect(interactor).to be_a_failure
			end
		end
	end

end