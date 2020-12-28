require "rails_helper"
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Viewing Financials", type: :feature do 
	let!(:franchise1) {create(:franchise)}
	let!(:franchise2) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise1)}
	let!(:financial1) {create(:financial, franchise: franchise1)}
	let!(:financial2) {create(:financial, franchise: franchise1, acct_monthly: 99999, year: Date.today.year+1)}
	let!(:financial3) {create(:financial, franchise: franchise2, acct_monthly: 88888)}
	
	scenario "Franchise User Can View His Financials List" do
		visit '/'
		simulate_user_sign_in(user)
		visit financials_path
		expect(page).to have_content(number_to_currency(financial1.total_revenues, precision: 2))
		expect(page).to have_content(number_to_currency(financial2.total_revenues, precision: 2))
		expect(page).to_not have_content(financial3.total_revenues)
	end

	scenario "Franchise User Can View One Specific Financial" do 
    visit '/'
    simulate_user_sign_in(user)
    visit financials_path
    within("table#financial-list") do 
    	first(".edit-link").click
    end

    expect(page).to have_field("Accounting Monthly", with: number_with_precision(financial2.acct_monthly, precision: 2))
    expect(page).to have_field("Payroll - Operations", with: number_with_precision(financial2.payroll_operation, precision: 2))
   
	
	end
end