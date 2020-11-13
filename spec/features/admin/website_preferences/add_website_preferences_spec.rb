require 'rails_helper'

RSpec.feature "Feature - Adding Website Preference", :type => :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  let!(:franchise2) {create(:franchise)}
  let!(:bank_account) {create(:bank_account, franchise: franchise)}

  scenario "Admin User Click Add Website Preference", js: true do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_website_preferences_path
    click_button "Add Website Preference"
     within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("website_preference_payment_method")
  end

  scenario "Admin User Can Add New Website Preference", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_website_preferences_path
    click_button "Add Website Preference"
    within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("website_preference_payment_method")
    
    find('label', :text => 'Basic').click
    #choose('website_preference_website_preference_0')
    select('Bank Account', from: 'Payment Method')
    option = find("#website_preference_bank_token > option:nth-child(2)").text
    select option, from: 'Account'
    click_button "Save Changes"
    expect(page).to have_content(franchise.lastname)
    expect(page).to have_content(franchise.firstname)
    expect(page).to_not have_content(franchise2.lastname)
  end

end
