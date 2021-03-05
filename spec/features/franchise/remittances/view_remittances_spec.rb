require "rails_helper"
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Viewing Remittances", type: :feature do 
	let!(:franchise1) {create(:franchise)}
	let!(:franchise2) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise1)}
	let!(:remittance1) {create(:remittance, :posted, franchise: franchise1)}
	let!(:remittance2) {create(:remittance, :pending, franchise: franchise1, accounting: 99999, year: Date.today.year+1)}
	let!(:remittance3) {create(:remittance, :posted, franchise: franchise2, accounting: 88888)}
	
	scenario "Franchise User Can View His Remittances List" do
		visit '/'
		simulate_user_sign_in(user)
		visit remittances_path
		
		within("table#pending-remittances-list") do
			expect(page) .to have_content(number_to_currency(remittance2.total_collections, precision: 2))
			expect(page) .to have_content(number_to_currency(remittance2.royalty, precision: 2))
			expect(page) .to have_content(number_to_currency(remittance2.total_due, precision: 2))
		end

		within("table#posted-remittances-list") do 
			expect(page) .to have_content(number_to_currency(remittance1.total_collections, precision: 2))
			expect(page) .to have_content(number_to_currency(remittance1.royalty, precision: 2))
			expect(page) .to have_content(number_to_currency(remittance1.total_due, precision: 2))

		end
	end

	scenario "Franchise User Can View One Specific Remittance" do 
    visit '/'
    simulate_user_sign_in(user)
    visit remittances_path
    within("table#pending-remittances-list") do 
    	first(".edit-link").click
    end

    expect(page).to have_field("Accounting", with: number_with_precision(remittance2.accounting, precision: 2))
    expect(page).to have_field("Actual Royalty", with: number_with_precision(remittance2.royalty, precision: 2))
   
	
	end
end