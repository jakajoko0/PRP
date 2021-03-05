require 'rails_helper'

RSpec.feature "Feature - Viewing Remittances", :type => :feature do 
  let!(:admin) {create(:admin)}	
  data = [{firstname: "Daniel", lastname: "Grenier"},{firstname: "Daniel", lastname: "Grenon"}, {firstname: "Daniel", lastname: "Grennier"} ]
  let!(:franchises) {data.map {|d| create(:franchise, d)}}
  let!(:remittances) {franchises.map {|f| create(:remittance, :pending,  franchise_id: f.id )}}

  
  scenario "Admin User Can view all Remittances" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_remittances_path
    remittances.each do |rem|
      expect(page).to have_content(rem.franchise.number_and_name)
    end
  
  end
end
