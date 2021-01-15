require 'rails_helper'

RSpec.feature "Feature - Deleting Charge", type: :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}
  let!(:trans_codes) {create_list(:transaction_code, 10, :charge)}
  let!(:prp_transactions) {create_list(:prp_transaction,10, :charge, franchise: franchise, trans_code: trans_codes[1])}
  
  
  scenario "Admin User Can delete one specific charge", js: true do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_charges_path
    desc = prp_transactions.last.trans_description
     accept_alert do 
      within("table#charge-list") do
        first(".delete-link").click
      end
    end

    sleep 1
    
    expect(page).to_not have_content(desc)
    
  end





end
