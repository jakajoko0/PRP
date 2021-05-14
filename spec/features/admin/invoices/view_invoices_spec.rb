require "rails_helper"
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Viewing Invoices", type: :feature do 
	let!(:admin) {create(:admin)}
	data = [{firstname: "Daniel", lastname: "Grenier"},{firstname: "Daniel", lastname: "Grenon"}, {firstname: "Daniel", lastname: "Grennier"} ]
	let!(:franchises) {data.map {|d| create(:franchise, d)}}
	let!(:invoices) {franchises.map {|f| create(:invoice,  franchise_id: f.id )}}
	
	scenario "Admin User Can View All Invoices List" do
		visit '/'
		simulate_admin_sign_in(admin)
		visit admins_invoices_path
		expect(page).to have_content(invoices.last.note)
		expect(page).to have_content(invoices.first.note)
	end

	scenario "Admin User Can View/Edit One Specific Invoice" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_invoices_path
    within("table#pending-charges-list") do 
    	first(".edit-link").click
    end

    expect(page).to have_field("Description", with: invoices.last.note)
	
	end
end