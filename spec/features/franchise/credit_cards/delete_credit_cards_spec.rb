require 'rails_helper'

RSpec.feature "Feature - Deleting Credit Card", :type => :feature do 
  
  let!(:franchise) {create(:franchise)}
  let!(:user) {create(:user, franchise: franchise)} 
  let!(:credit_card1) {create(:credit_card,card_type: "V",cc_type: "V",franchise: franchise)}
  let!(:credit_card2) {create(:credit_card,card_type: "M", cc_type: "M",franchise: franchise)}
  

  scenario "Franchise User Can delete one of their Credit Card", js: true do 
    expir = "#{credit_card1.exp_month} / #{credit_card1.exp_year}"
    last_four = credit_card1.last_four

    visit '/'
    simulate_user_sign_in(user)
    visit credit_cards_path
     accept_alert do 
      within("table#credit-card-list") do
        first(".delete-link").click
      end
    end

    sleep 1
    
    
    expect(get_table_cell_text('credit-card-list',1,2)).to_not have_content(last_four)
    expect(page.all('#credit-card-list tbody tr').count).to eq(1)
    
  end





end
