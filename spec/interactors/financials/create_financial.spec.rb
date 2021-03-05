require "rails_helper"

RSpec.describe "Interactor - CreateFinancial", :type => :interactor do 
	let!(:user) {create(:user)}
	let!(:fran) {create(:franchise)}
	let!(:params) {FactoryBot.attributes_for(:financial)}

	describe ".call" do 
		context "When given valid attributes" do
		subject {CreateFinancial.call(params: params.merge(franchise_id:fran.id) , user: user)} 
			it "should create financial" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(interactor.financial).to eq(Financial.last)
			end

			it "should log an event" do 
				expect{subject}.to change{EventLog.count}.by(1)
			end

		end

		context "When given invalid attributes" do 
			subject {CreateFinancial.call(params: params.merge(year: nil), user: user)}
			it "should not create financial" do 
				interactor = subject
				expect(interactor).to be_a_failure
			end

			it "should not log an event" do 
				expect{subject}.to_not change{EventLog.count}
			end

		end
	end

end