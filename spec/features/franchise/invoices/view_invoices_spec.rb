require "rails_helper"
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Viewing Invoices", type: :feature do 
	let!(:franchise1) {create(:franchise)}
	let!(:franchise2) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise1)}
	let!(:invoice1) {create(:invoice, franchise: franchise1, note: "First Note")}
	let!(:invoice2) {create(:invoice, franchise: franchise1, note: "Another Note" )}
	let!(:invoice3) {create(:invoice, franchise: franchise2, note: "Note from Franchise2")}
	
	scenario "Franchise User Can View His Invoice List" do
		visit '/'
		simulate_user_sign_in(user)
		visit invoices_path
		expect(page).to have_content(invoice1.note)
		expect(page).to have_content(invoice2.note)
		expect(page).to_not have_content(invoice3.note)
	end

	scenario "Franchise User Can View One Specific Invoice" do 
    visit '/'
    simulate_user_sign_in(user)
    visit invoices_path
    within("table#pending-charges-list") do 
    	first(".edit-link").click
    end

    expect(page).to have_field("Description", with: invoice2.note)
	
	end
end