require "rails_helper"

RSpec.describe "CreateInsurance", :type => :interactor do 
	let!(:admin) {create(:admin)}
	let!(:glass) {create :franchise, lastname: "Glass", firstname: "Forrest"}
	let!(:params) {FactoryBot.attributes_for(:insurance,franchise_id: glass.id)}


	describe ".call" do 
		context "When given valid attributes" do 
			it "should create insurance" do 
				interactor = CreateInsurance.call(params: params, user: admin)
				expect(interactor).to be_a_success
				expect(interactor.insurance).to eq(Insurance.last)
			end

			it "should log an event" do 
				expect{CreateInsurance.call(params: params, user: admin)}.to change{EventLog.count}.by(1)
			end

		end

		context "When given invalid attributes" do 
			it "should not create insurance" do 
				interactor = CreateInsurance.call(params: params.merge(other_insurance: 1, other_description: nil), user: admin)
				expect(interactor).to be_a_failure
			end

			it "should not log an event" do 
				expect{CreateInsurance.call(params: params.merge(other_insurance: 1, other_description: nil), user: admin)}.to_not change{EventLog.count}
			end

		end
	end

end