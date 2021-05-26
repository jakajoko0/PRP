require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Deleting Deposit", :type => :feature do 
  
  let!(:franchise) {create(:franchise)}
  let!(:user) {create(:user, franchise: franchise)} 
  let!(:deposit1) {create(:deposit_tracking, franchise: franchise, accounting: 2000, total_deposit: 15000 )}
  let!(:deposit2) {create(:deposit_tracking, franchise: franchise, accounting: 2666, total_deposit: 15666)}
  

  scenario "Franchise User Can delete one of their Deposit", js: true do 
    acct = deposit2.accounting
    visit '/'
    simulate_user_sign_in(user)
    visit deposit_trackings_path
     accept_alert do 
      within("table#deposits-list") do
        first(".delete-link").click
      end
    end

    sleep 1
    
    
    expect(get_table_cell_text('deposits-list',1,2)).to_not have_content(number_to_currency(acct))
    expect(page.all('#deposits-list tbody tr').count).to eq(1)
    
  end





end
