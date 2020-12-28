require "rails_helper"

RSpec.describe "Interactor - UpdateFinancial", :type => :interactor do 
	let!(:user) {create(:user)}
	let!(:fran)    {create :franchise}
	let!(:financial) {create :financial, franchise: fran}
	let(:changed_attributes) {financial.attributes.symbolize_keys.merge(acct_monthly: 99999)}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should update financial" do 
				interactor = UpdateFinancial.call(financial: financial,params: changed_attributes, user: user)
				expect(interactor).to be_a_success
				expect(financial.reload.acct_monthly).to eq changed_attributes[:acct_monthly]
			end

			
			it "should log an event" do 
				expect{UpdateFinancial.call(financial: financial,params: changed_attributes, user: user)}.to change{EventLog.count}.by(1)
			end

		end

		context "When given invalid attributes" do 
			it "should not update financial" do 
				interactor = UpdateFinancial.call(financial: financial,params: changed_attributes.merge(year: nil), user: user)
				expect(interactor).to be_a_failure
				expect(financial.reload.acct_monthly).to_not eq changed_attributes[:acct_monthly]
			end

			it "should not log an event" do 
				expect{UpdateFinancial.call(financial: financial,params: changed_attributes.merge(year: nil), user: user)}.to_not change{EventLog.count}
			end

		end
	end

end