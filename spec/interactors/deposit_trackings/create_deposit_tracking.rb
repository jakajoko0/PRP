require "rails_helper"

RSpec.describe "Interactor - CreateDepositTracking", :type => :interactor do 
	let!(:user) {create(:user)}
	let!(:fran) {create(:franchise)}
	let!(:params) {FactoryBot.attributes_for(:deposit_tracking, deposit_date: Date.today.strftime("%m/%d/%Y"))}

	describe ".call" do 
		context "When given valid attributes" do
		subject {CreateDepositTracker.call(params: params.merge(franchise_id:fran.id) , user: user)} 
			it "should create deposit tracker" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(interactor.deposit_tracking).to eq(DepositTracking.last)
			end

		end

		context "When given invalid attributes" do 
			subject {CreateDepositTracker.call(params: params.merge(year: nil), user: user)}
			it "should not create deposit tracker" do 
				interactor = subject
				expect(interactor).to be_a_failure
			end

		end
	end

end