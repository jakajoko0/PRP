require "rails_helper"


RSpec.describe "Interactor - CreateWebsitePreference", :type => :interactor do 
	let!(:fran) {create :franchise}
	let!(:user) {create(:user)}
	let!(:params) {attributes_for(:website_preference_create)}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should create website preference" do 
			  interactor = CreateWebsitePreference.call(params: params.merge(franchise: fran), user: user)
				expect(interactor).to be_a_success
				expect(interactor.website_preference).to eq(WebsitePreference.last)
			end
		end

		context "When given invalid attributes" do 
			it "should not create website preference" do 
				interactor = CreateWebsitePreference.call(params: params.merge(payment_method: 'ach', bank_token: nil), user: user)
				expect(interactor).to be_a_failure
			end
		end
	end
end