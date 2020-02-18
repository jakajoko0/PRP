require 'rails_helper'

RSpec.feature "Deleting Accountants", :type => :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  let!(:accountants) {create_list(:accountant,10, franchise: franchise)}
  

  scenario "Admin User Can delete one specific accountant", js: true do 
    fname = accountants.first.lastname
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_accountants_path
     accept_alert do 
      within("table#accountant-list") do
        first(".delete-link").click
      end
    end

    sleep 1
    
    expect(page).to_not have_content(fname)
    
  end





end
