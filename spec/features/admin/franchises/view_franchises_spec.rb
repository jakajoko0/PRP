require 'rails_helper'

RSpec.feature "Feature - Viewing Franchises", :type => :feature do 
  let!(:admin) {create(:admin)}	
  data = [{firstname: "AAAA", lastname: "BBBB"},{firstname: "BBBB", lastname: "AAAA"}, {firstname: "AAAB", lastname: "BBBA"} ]
  let!(:franchises) {data.map {|d| create(:franchise, d)}}
  
  scenario "Admin User Can view all Franchises" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchises_path
    franchises.each do |fr|
      expect(page).to have_content(fr.full_name)
    end
  
  end


  scenario "Admin User Can view one specific franchise" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchises_path
    within("table#franchise-list") do
      first(".show-link").click
    end
    
    expect(page).to have_content(franchises.first.firstname)
    expect(page).to have_content(franchises.first.lastname)
    expect(page).to have_content(franchises.first.address)
    expect(page).to have_content(franchises.first.email)
    expect(page).to_not have_content(franchises.last.firstname)
  end


end
