require 'rails_helper'

RSpec.feature "Viewing Insurance", :type => :feature do 
  let!(:admin) {create(:admin)}	
  data = [{firstname: "Daniel", lastname: "Grenier"},{firstname: "Daniel", lastname: "Grenon"}, {firstname: "Daniel", lastname: "Grennier"} ]
  let!(:franchises) {data.map {|d| create(:franchise, d)}}
  let!(:insurances) {franchises.map {|f| create(:insurance, franchise_id: f.id )}}

  
  scenario "Admin User Can view all Insurance" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_insurances_path
    insurances.each do |i|
      expect(page).to have_content(i.franchise.lastname)
    end
  
  end

  

  


end
