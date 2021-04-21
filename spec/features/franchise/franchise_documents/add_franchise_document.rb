require 'rails_helper'

RSpec.feature "Feature - Adding Franchise Document", type: :feature do 
  let!(:franchise) {create(:franchise)}
  let!(:user) {create(:user, franchise: franchise)}
	
  scenario "User can Create a Valid Franchise Document", js: true do 
    visit '/'	
    simulate_user_sign_in(user)
    visit franchise_documents_path
    click_button("Attach Document")
    expect(page).to have_content("Attach New Document")
    select("Tax Return", from: "Document type")
    fill_in "Description", with: "My New Tax Return"
    attach_file('franchise_document_document', Rails.root.join('spec','factories','files','taxreturn2020.xlsx'), make_visible: true)
    click_button "Save"
    pp page.body
    expect(get_table_cell_text('document-list',1,2)).to eq("Tax return")
    expect(get_table_cell_text('document-list',1,3)).to eq("My New Tax Return")

  end

  scenario "User cannot Create an Invalid Franchise Document", js: true do 
    visit '/'	
    simulate_user_sign_in(user)
    visit franchise_documents_path
    click_button("Attach Document")
    expect(page).to have_content("Attach New Document")
    select("Tax Return", from: "Document type")
    fill_in "Description", with: "My New Tax Return"
    attach_file('franchise_document_document',Rails.root.join('spec','factories','files','TextFile.txt'), make_visible: true)
    click_button "Save"
    expect(page).to have_selector(:id, 'error_explanation')
    
  end
end