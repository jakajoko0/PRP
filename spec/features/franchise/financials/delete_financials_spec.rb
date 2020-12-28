require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Deleting Financial", :type => :feature do 
  
  let!(:franchise) {create(:franchise)}
  let!(:user) {create(:user, franchise: franchise)} 
  let!(:financial1) {create(:financial, franchise: franchise, year: 2021)}
  let!(:financial2) {create(:financial, franchise: franchise, year: 2020, acct_monthly: 9999)}
  

  scenario "Franchise User Can delete one of their Finacnial", js: true do 
    total_rev = financial1.total_revenues
    visit '/'
    simulate_user_sign_in(user)
    visit financials_path
     accept_alert do 
      within("table#financial-list") do
        first(".delete-link").click
      end
    end

    sleep 1
    
    
    expect(get_table_cell_text('financial-list',1,3)).to_not have_content(number_to_currency(total_rev))
    expect(page.all('#financial-list tbody tr').count).to eq(1)
    
  end





end
