require 'rails_helper'

RSpec.feature "Viewing Accountants", :type => :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  data = [{firstname: "AAAA", lastname: "BBBB"},{firstname: "BBBB", lastname: "AAAA"}, {firstname: "AAAB", lastname: "BBBA"} ]
  let!(:accountants) {data.map {|d| create(:accountant, d )}}
  
  scenario "Admin User Can view all Accountants" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_accountants_path
    accountants.each do |a|
      expect(page).to have_content(a.firstname)
      expect(page).to have_content(a.lastname)
    end
  
  end

  scenario "Admin User Can Filter Accountants by Name", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_accountants_path
    expect(page).to have_button("Add Accountant")
    fill_in "search", with: "AAAB"
    
    expect(page).to have_content(accountants.last.firstname)
    expect(page).to have_content(accountants.last.lastname)
    expect(page).to_not have_content(accountants.first.firstname)
  
  end

  


end
