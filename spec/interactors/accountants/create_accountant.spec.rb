require "rails_helper"

RSpec.describe "Interactor - CreateAccountant", :type => :interactor do 
	let!(:admin) {create(:admin)}
	let!(:glass) {create :franchise, lastname: "Glass", firstname: "Forrest"}
	let!(:params) {FactoryBot.attributes_for(:accountant,franchise_id: glass.id, start_date: nil, birthdate: nil, spouse_birthdate: nil)}


	describe ".call" do 
		context "When given valid attributes" do 
			it "should create accountant" do 
				interactor = CreateAccountant.call(params: params, user: admin)
				expect(interactor).to be_a_success
				expect(interactor.accountant).to eq(Accountant.last)
			end

			it "should log an event" do 
				expect{CreateAccountant.call(params: params, user: admin)}.to change{EventLog.count}.by(1)
			end

		end

		context "When given invalid attributes" do 
			it "should not create insurance" do 
				interactor = CreateAccountant.call(params: params.merge(lastname: nil), user: admin)
				expect(interactor).to be_a_failure
			end

			it "should not log an event" do 
				expect{CreateAccountant.call(params: params.merge(lastname: nil), user: admin)}.to_not change{EventLog.count}
			end

		end
	end

end