require "rails_helper"

RSpec.describe "Interactor - UpdateCredit", type: :interactor do 
	let!(:admin) {create(:admin)}
	let!(:fran)    {create :franchise}
	let!(:credit_trans) {create :prp_transaction, :credit, franchise: fran}
	let!(:changed_attributes) {credit_trans.attributes.symbolize_keys.merge(amount: 999.99, date_posted: '02/01/2021')}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should update credit" do 
				interactor = UpdateCredit.call(credit: credit_trans,params: changed_attributes, user: admin)
				expect(interactor).to be_a_success
				expect(credit_trans.reload.amount).to eq changed_attributes[:amount]
			end

		end

		context "When given invalid attributes" do 
			it "should not update credit" do 
				interactor = UpdateCredit.call(credit: credit_trans, params: changed_attributes.merge(amount: -100), user: admin)
			  expect(interactor).to be_a_failure
			  expect(credit_trans.reload.amount).to_not eq -100
			end


		end
	end

end