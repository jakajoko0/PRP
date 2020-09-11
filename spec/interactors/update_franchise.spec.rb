require "rails_helper"

RSpec.describe "UpdateFranchise", :type => :interactor do 
	let!(:admin) {create(:admin)}
	let!(:glass)    {create :franchise, lastname: "Glass", firstname: "Forrest"}
	let(:changed_attributes) {glass.attributes.symbolize_keys.merge(lastname: "New Lastname",  start_date:'01/01/2019', renew_date: '01/01/2024' )}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should update franchise" do 
				interactor = UpdateFranchise.call(franchise: glass,params: changed_attributes, user: admin)
				expect(interactor).to be_a_success
				expect(glass.reload.lastname).to eq changed_attributes[:lastname]
			end

			it "should not log an event when advanced rebate not changed " do 
				expect{UpdateFranchise.call(franchise: glass,params: changed_attributes, user: admin)}.to_not change{EventLog.count}
			end

			it "should log an event when advanced rebate changed" do 
				expect{UpdateFranchise.call(franchise: glass,params: changed_attributes.merge(advanced_rebate: 99), user: admin)}.to change{EventLog.count}.by(1)
			end

		end

		context "When given invalid attributes" do 
			it "should not update franchise" do 
				interactor = UpdateFranchise.call(franchise: glass,params: changed_attributes.merge(firstname: nil), user: admin)
				expect(interactor).to be_a_failure
				expect(glass.reload.lastname).to_not eq changed_attributes[:lastname]
			end

			it "should not log an event" do 
				expect{UpdateFranchise.call(franchise: glass,params: changed_attributes.merge(firstname: nil), user: admin)}.to_not change{EventLog.count}
			end

		end
	end

end