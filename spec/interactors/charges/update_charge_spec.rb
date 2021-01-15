require "rails_helper"

RSpec.describe "Interactor - UpdateCharge", type: :interactor do 
	let!(:admin) {create(:admin)}
	let!(:fran)    {create :franchise}
	let!(:charge_trans) {create :prp_transaction, :charge, franchise: fran}
	let!(:changed_attributes) {charge_trans.attributes.symbolize_keys.merge(amount: 999.99, date_posted: '02/01/2021')}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should update charge" do 
				interactor = UpdateCharge.call(charge: charge_trans,params: changed_attributes, user: admin)
				expect(interactor).to be_a_success
				expect(charge_trans.reload.amount).to eq changed_attributes[:amount]
			end

		end

		context "When given invalid attributes" do 
			it "should not update charge" do 
				interactor = UpdateCharge.call(charge: charge_trans, params: changed_attributes.merge(amount: -100), user: admin)
			  expect(interactor).to be_a_failure
			  expect(charge_trans.reload.amount).to_not eq changed_attributes[:amount]
			end


		end
	end

end