require "rails_helper"

RSpec.describe "Interactor - UpdateDepositTracker", :type => :interactor do 
	let!(:user) {create(:user)}
	let!(:fran)    {create :franchise}
	let!(:deposit_tracking) {create :deposit_tracking, franchise: fran}
	let!(:changed_attributes) {deposit_tracking.attributes.symbolize_keys.merge(accounting: 2000, total_deposit: 15000,  deposit_date:  Date.today.strftime("%m/%d/%Y"))}

	describe ".call" do 
		context "When given valid attributes" do 
			subject {UpdateDepositTracker.call(deposit_tracking: deposit_tracking,params: changed_attributes, user: user)}
			it "should update deposit tracking" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(deposit_tracking.reload.accounting).to eq changed_attributes[:accounting]
			end

		end

		context "When given invalid attributes" do 
			subject {UpdateDepositTracker.call(deposit_tracking: deposit_tracking,params: changed_attributes.merge(setup: -1), user: user)}
			it "should not update deposit tracking" do 
				interactor = subject
				expect(interactor).to be_a_failure
				expect(deposit_tracking.reload.accounting).to_not eq changed_attributes[:accounting]
			end

		end
	end

end