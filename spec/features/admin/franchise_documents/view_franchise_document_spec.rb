require 'rails_helper'

RSpec.feature "Feature - Viewing Franchise Documents", :type => :feature do 
  let!(:admin) {create(:admin)}	
  data = [{firstname: "Daniel", lastname: "Grenier"},{firstname: "Daniel", lastname: "Grenon"}, {firstname: "Daniel", lastname: "Grennier"} ]
  let!(:franchises) {data.map {|d| create(:franchise, d)}}
  let!(:documents) {franchises.map {|f| create(:franchise_document, franchise_id: f.id )}}

  
  scenario "Admin User Can view all Franchise Documents" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchise_documents_path
    documents.each do |i|
      expect(page).to have_content(i.description)
    end
  
  end


end
