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

  scenario "Admin User Can Filter Insurance by Franchise Name", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_insurances_path
    fill_in "search", with: "Gre"
    sleep 1
    franchises.each do |fr|
      expect(page).to have_content(fr.lastname)
    end
    
    fill_in "search", with: "Gren"
    sleep 1
    expect(page).to have_content(franchises.first.lastname)
    expect(page).to have_content(franchises.second.lastname)
    
    fill_in "search", with: "Grenn"
    sleep 1
    expect(page).to have_content(franchises.last.lastname)
    expect(page).to_not have_content(franchises.first.lastname)
  
  end

  


end
