require "rails_helper"

RSpec.describe "Interactor - UpdateInsurance", :type => :interactor do 
	let!(:admin) {create(:admin)}
	let!(:glass)    {create :franchise, lastname: "Glass", firstname: "Forrest"}
	let!(:glass_insurance) {create :insurance, franchise_id: glass.id}
	let!(:changed_attributes) {glass_insurance.attributes.symbolize_keys.merge(eo_insurance: 1, eo_expiration: '01/01/2024')}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should update insurance" do 
				interactor = UpdateInsurance.call(insurance: glass_insurance,params: changed_attributes, user: admin)
				expect(interactor).to be_a_success
				expect(glass_insurance.reload.eo_insurance).to eq changed_attributes[:eo_insurance]
			end

			it "should log an event " do 
				expect{UpdateInsurance.call(insurance: glass_insurance,params: changed_attributes, user: admin)}.to change{EventLog.count}.by(1)
			end

		end

		context "When given invalid attributes" do 
			it "should not update insurance" do 
				interactor = UpdateInsurance.call(insurance: glass_insurance, params: changed_attributes.merge(other_insurance: 1, other_expiration: nil), user: admin)
			  expect(interactor).to be_a_failure
			  expect(glass_insurance.reload.other_insurance).to_not eq 1
			end

			it "should not log an event" do 
				expect{UpdateInsurance.call(insurance: glass_insurance, params: changed_attributes.merge(other_insurance: 1, other_expiration: nil), user: admin)}.to_not change{EventLog.count} 
			end
		end
	end

end