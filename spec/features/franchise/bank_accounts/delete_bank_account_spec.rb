require 'rails_helper'

RSpec.feature "Feature - Deleting Bank Accounts", :type => :feature do 
  
  let!(:franchise) {create(:franchise)}
  let!(:user) {create(:user, franchise: franchise)} 
  let!(:bank_account1) {create(:bank_account,bank_name: "Bank of America", last_four: "6789",franchise: franchise)}
  let!(:bank_account2) {create(:bank_account,bank_name: "Chase", last_four: "1234",franchise: franchise)}
  

  scenario "Franchise User Can delete one of their Bank Account", js: true do 
    bname = bank_account1.bank_name
    lastfour = bank_account1.last_four
    acctype = bank_account1.account_type
    visit '/'
    simulate_user_sign_in(user)
    visit bank_accounts_path
     accept_alert do 
      within("table#bank-account-list") do
        first(".delete-link").click
      end
    end

    sleep 1
    
    
    expect(get_table_cell_text('bank-account-list',1,3)).to_not have_content(lastfour)
    expect(get_table_cell_text('bank-account-list',1,1)).to_not have_content(bname)
    expect(page.all('#bank-account-list tbody tr').count).to eq(1)
    
  end





end
