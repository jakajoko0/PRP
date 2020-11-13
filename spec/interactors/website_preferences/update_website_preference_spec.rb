require "rails_helper"

RSpec.describe "Interactor - UpdateWebsitePreference", :type => :interactor do 
	let!(:fran) {create(:franchise)}
	let!(:user) {create(:user)}
	let!(:website_pref) {create :website_preference, :ach, franchise: fran}
	let(:changed_attributes) {website_pref.attributes.symbolize_keys.merge(website_preference: 0, payment_method: 'credit_card', card_token: 'AAABC_DEF')}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should update website preference" do 
				interactor = UpdateWebsitePreference.call(website_preference: website_pref,params: changed_attributes, user: user)
				expect(interactor).to be_a_success
				expect(website_pref.reload.payment_token).to eq changed_attributes[:card_token]
			end

		end

		context "When given invalid attributes" do 
			it "should not update website preference" do 
				interactor = UpdateWebsitePreference.call(website_preference: website_pref, params: changed_attributes.merge(payment_method: 'credit_card', card_token: nil), user: user)
				expect(interactor).to be_a_failure
				expect(website_pref.reload.payment_method).to_not eq 'credit_card'
				expect(website_pref.reload.payment_method).to_not eq nil
			end

		end
	end

end