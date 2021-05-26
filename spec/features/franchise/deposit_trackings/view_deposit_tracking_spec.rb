require "rails_helper"
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Viewing Deposits", type: :feature do 
	let!(:franchise1) {create(:franchise)}
	let!(:franchise2) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise1)}
	let!(:deposit1) {create(:deposit_tracking, franchise: franchise1)}
	let!(:deposit2) {create(:deposit_tracking, franchise: franchise1, accounting: 6000, total_deposit: 19000)}
	let!(:deposit3) {create(:deposit_tracking, franchise: franchise2, payroll: 6666, total_deposit: 18666)}
	
	scenario "Franchise User Can View His Deposits List" do
		visit '/'
		simulate_user_sign_in(user)
		visit deposit_trackings_path
		expect(page).to have_content(number_to_currency(deposit2.accounting, precision: 2))
		expect(page).to_not have_content(number_to_currency(deposit3.payroll, precision: 2))
	end

	scenario "Franchise User Can View One Specific Deposit" do 
    visit '/'
    simulate_user_sign_in(user)
    visit deposit_trackings_path
    within("table#deposits-list") do 
    	first(".edit-link").click
    end

    expect(page).to have_field("Accounting", with: number_with_precision(deposit2.accounting, precision: 2))
    expect(page).to have_field("Payroll", with: number_with_precision(deposit2.payroll, precision: 2))
  
	
	end
end