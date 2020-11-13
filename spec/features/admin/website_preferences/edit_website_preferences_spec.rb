require 'rails_helper'

RSpec.feature "Feature - Editing Website Preference", :type => :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  let!(:bank_account) {create(:bank_account, franchise: franchise)}
  let!(:website_preference) {create(:website_preference, :ach, bank_token: bank_account.bank_token, payment_token: bank_account.bank_token , franchise: franchise)}

  

  scenario "Admin User Can edit Website Preference record" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_website_preferences_path
    within("table#website-preference-list") do
      first(".edit-link").click
    end
    
    expect(page).to have_field("website_preference_payment_method", with: website_preference.payment_method)
  end

  scenario "Admin User Can change data of one specific website preference record", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_website_preferences_path
    within("table#website-preference-list") do
      first(".edit-link").click
    end

    expect(page).to have_field("website_preference_payment_method", with: website_preference.payment_method)
    expect(page).to have_button("Save Changes")
    find('label', :text => 'Custom').click
    find('input[name="submit"]').click
    expect(page).to have_content("Custom")
    expect(page).to have_content(franchise.lastname)
    expect(page).to have_content(website_preference.reload.current_fee)
  end


end
