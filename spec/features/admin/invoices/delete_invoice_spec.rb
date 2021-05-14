require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Deleting Invoice", type: :feature do 
  let!(:admin) {create(:admin)} 
  let!(:franchise) {create(:franchise)}
  data = [{firstname: "Daniel", lastname: "Grenier"},{firstname: "Daniel", lastname: "Grenon"}, {firstname: "Daniel", lastname: "Grennier"} ]
  let!(:franchises) {data.map {|d| create(:franchise, d)}}
  let!(:invoices) {franchises.map {|f| create(:invoice,  franchise_id: f.id )}}  

  scenario "Admin User Can delete an Invoice", js: true do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_invoices_path
     accept_alert do 
      within("table#pending-charges-list") do
        first(".delete-link").click
      end
    end

    sleep 1
    
    expect(get_table_cell_text('pending-charges-list',1,2)).to_not have_content(invoices.last.note)
    expect(page.all('#pending-charges-list tbody tr').count).to eq(2)
    
  end





end
