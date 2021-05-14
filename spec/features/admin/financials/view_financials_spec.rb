require 'rails_helper'

RSpec.feature "Feature - Viewing Financials", type: :feature do 
  let!(:admin) {create(:admin)}	
  data = [{firstname: "Daniel", lastname: "Grenier"},{firstname: "Daniel", lastname: "Grenon"}, {firstname: "Daniel", lastname: "Grennier"} ]
  let!(:franchises) {data.map {|d| create(:franchise, d)}}
  let!(:financials) {franchises.map {|f| create(:financial,  franchise_id: f.id )}}

  
  scenario "Admin User Can view all Financials" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_financials_path
    financials.each do |rem|
      expect(page).to have_content(rem.franchise.number_and_name)
    end
  
  end
end
