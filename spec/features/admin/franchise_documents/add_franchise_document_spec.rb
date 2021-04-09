require 'rails_helper'

RSpec.feature "Feature - Adding Franchise Document", type: :feature do 
  let!(:admin) {create(:admin)}	
  let!(:franchise) {create(:franchise)}

  scenario "Admin User Click Add Franchise Document", js: true do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchise_documents_path
    click_button "Attach Document"
     within("table#franchise-list") do
      first(".btn").click
    end
    expect(page).to have_field("franchise_document_document_type")
  end

  scenario "Admin User Can Add New Franchise Document", js: true  do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_franchise_documents_path
    click_button "Attach Document"
    within("table#franchise-list") do
      first(".btn").click
    end
    select("Tax Return", from: "Document type")
    fill_in "Description", with: "My New Tax Return"
    attach_file('franchise_document_document',Rails.root.join('spec','factories','files','taxreturn2020.xlsx'))
    click_button "Save"
    expect(get_table_cell_text('document-list',1,3)).to eq("Tax return")
    expect(get_table_cell_text('document-list',1,4)).to eq("My New Tax Return")

  end

end
