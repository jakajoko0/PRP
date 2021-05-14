require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.feature "Feature - Deleting Financial", :type => :feature do 
  
  let!(:admin) {create(:admin)} 
  data = [{firstname: "Daniel", lastname: "Grenier"},{firstname: "Daniel", lastname: "Grenon"}, {firstname: "Daniel", lastname: "Grennier"} ]
  let!(:franchises) {data.map {|d| create(:franchise, d)}}
  let!(:financials) {franchises.map {|f| create(:financial,  franchise_id: f.id )}}  

  scenario "Admin User Can delete one Finacnial", js: true do 
    total_rev = financials.last.total_revenues
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_financials_path
     accept_alert do 
      within("table#financial-list") do
        first(".delete-link").click
      end
    end

    sleep 1
    
    
    expect(get_table_cell_text('financial-list',1,1)).to_not have_content(financials.last.franchise.number_and_name)
    expect(page.all('#financial-list tbody tr').count).to eq(2)
    
  end





end
