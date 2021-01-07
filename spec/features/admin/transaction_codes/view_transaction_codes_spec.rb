require 'rails_helper'

RSpec.feature "Feature - Viewing Transaction Codes", :type => :feature do 
  let!(:admin) {create(:admin)}	
  let!(:trans_code) {create_list(:transaction_code, 4)}

  
  scenario "Admin User Can view all Transaction Codes" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_transaction_codes_path
    trans_code.each do |tc|
      expect(page).to have_content(tc.description)
      expect(page).to have_content(tc.code)
    end
  
  end
end
