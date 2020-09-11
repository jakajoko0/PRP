require "rails_helper"

RSpec.describe "CreateFranchise", :type => :interactor do 
	let!(:admin) {create(:admin)}
	let!(:params) {FactoryBot.attributes_for(:franchise, start_date: '01/01/2019', renew_date: '01/01/2024')}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should create franchise" do 
				interactor = CreateFranchise.call(params: params, user: admin)
				expect(interactor).to be_a_success
				expect(interactor.franchise).to eq(Franchise.last)
			end

			it "should log an event" do 
				expect{CreateFranchise.call(params: params, user: admin)}.to change{EventLog.count}.by(1)
			end

		end

		context "When given invalid attributes" do 
			it "should not create franchise" do 
				interactor = CreateFranchise.call(params: params.merge(lastname: nil), user: admin)
				expect(interactor).to be_a_failure
			end

			it "should not log an event" do 
				expect{CreateFranchise.call(params: params.merge(lastname: nil), user: admin)}.to_not change{EventLog.count}
			end

		end
	end

end