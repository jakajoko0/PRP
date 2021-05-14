require "rails_helper"
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Editing Financial", type: :feature do 
  let!(:admin) {create(:admin)}
	data = [{firstname: "Daniel", lastname: "Grenier"},{firstname: "Daniel", lastname: "Grenon"}, {firstname: "Daniel", lastname: "Grennier"} ]
  let!(:franchises) {data.map {|d| create(:franchise, d)}}
  let!(:financials) {franchises.map {|f| create(:financial,  franchise_id: f.id )}}
	
	scenario "Admin User Can Edit One Specific Financial", js: true do 

    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_financials_path
    
    within("table#financial-list") do 
    	first(".edit-link").click
    end

    expect(page).to have_field("Accounting Monthly", with: "1000.00")
    expect(page).to have_field("Payroll - Operations", with: "100.00")

    fill_in('Accounting Monthly', with: '5000.00')
    
    find('input[name="submit"]').click

    expect(page).to have_content(number_to_currency(25000, precision: 2))
	
	end

scenario "Admin User Cannot Save With Negative Number", js: true do 

	visit '/'
  simulate_admin_sign_in(admin)
  visit admins_financials_path
    
  within("table#financial-list") do 
  	first(".edit-link").click
  end

  expect(page).to have_field("Accounting Monthly", with: "1000.00")
  expect(page).to have_field("Payroll - Operations", with: "100.00")

  fill_in('Accounting Monthly', with: '-10000.00')
  
  find('input[name="submit"]').click

  expect(page).to have_selector(:id, 'error_explanation')
  page.find("#financial_acct_monthly")[:class].include?("is-invalid")

end

end