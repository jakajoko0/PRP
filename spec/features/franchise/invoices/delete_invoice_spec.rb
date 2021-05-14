require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Deleting Invoice", :type => :feature do 
  
  let!(:franchise) {create(:franchise)}
  let!(:user) {create(:user, franchise: franchise)} 
  let!(:my_invoice) {create(:invoice, franchise: franchise, note: "First Invoice")}
  let!(:my_invoice2) {create(:invoice, franchise: franchise, note: "Second Invoice")}
  

  scenario "Franchise User Can delete one of their Invoice", js: true do 
    visit '/'
    simulate_user_sign_in(user)
    visit invoices_path
     accept_alert do 
      within("table#pending-charges-list") do
        first(".delete-link").click
      end
    end

    sleep 1
    
    expect(get_table_cell_text('pending-charges-list',1,2)).to_not have_content(my_invoice2.note)
    expect(page.all('#pending-charges-list tbody tr').count).to eq(1)
    
  end





end
