require "rails_helper"

RSpec.describe "Interactor - CreateFinancial", :type => :interactor do 
	let!(:user) {create(:user)}
	let!(:fran) {create(:franchise)}
	let!(:params) {FactoryBot.attributes_for(:financial)}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should create financial" do 
				interactor = CreateFinancial.call(params: params.merge(franchise_id:fran.id) , user: user)
				expect(interactor).to be_a_success
				expect(interactor.financial).to eq(Financial.last)
			end

			it "should log an event" do 
				expect{CreateFinancial.call(params: params.merge(franchise_id: fran.id), user: user)}.to change{EventLog.count}.by(1)
			end

		end

		context "When given invalid attributes" do 
			it "should not create financial" do 
				interactor = CreateFinancial.call(params: params.merge(year: nil), user: user)
				expect(interactor).to be_a_failure
			end

			it "should not log an event" do 
				expect{CreateFinancial.call(params: params.merge(year: nil), user: user)}.to_not change{EventLog.count}
			end

		end
	end

end