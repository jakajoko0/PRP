require "rails_helper"

RSpec.describe "UpdateAccountant", :type => :interactor do 
	let!(:admin) {create(:admin)}
	let!(:glass)    {create :franchise, lastname: "Glass", firstname: "Forrest"}
	let!(:glass_accountant) {create :accountant, franchise: glass}
	let(:changed_attributes) {glass_accountant.attributes.symbolize_keys.merge(lastname: "New Lastname",  start_date:'01/01/2019', birthdate: '01/01/2024', spouse_birthdate: '01/01/2024' )}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should update accountant" do 
				interactor = UpdateAccountant.call(accountant: glass_accountant,params: changed_attributes, user: admin)
				expect(interactor).to be_a_success
				expect(glass_accountant.reload.lastname).to eq changed_attributes[:lastname]
			end

		end

		context "When given invalid attributes" do 
			it "should not update accountant" do 
				interactor = UpdateAccountant.call(accountant: glass_accountant, params: changed_attributes.merge(firstname: nil), user: admin)
				expect(interactor).to be_a_failure
				expect(glass_accountant.reload.firstname).to_not eq nil
			end

		end
	end

end