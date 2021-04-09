require "rails_helper"

RSpec.feature "Feature - Viewing Franchise Documents", type: :feature do 
	let!(:franchise1) {create(:franchise)}
	let!(:user) {create(:user, franchise: franchise1)}
	let!(:franchise2) {create(:franchise)}
	let!(:document1) {create(:franchise_document, franchise: franchise1, document:Rack::Test::UploadedFile.new(Rails.root.join('spec','factories','files','taxreturn2020.xlsx'),'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'))}
	let!(:document2) {create(:franchise_document, franchise: franchise2, document:Rack::Test::UploadedFile.new(Rails.root.join('spec','factories','files','taxreturn2021.xlsx'),'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'))}
   
  
  
	scenario "Franchise User Can View His Documents" do
		visit '/'
		simulate_user_sign_in(user)
		visit franchise_documents_path
		expect(page).to have_content(document1.description)
	end

	scenario "Franchise User Cannot View Other Franchise Documents" do
		visit '/'
		simulate_user_sign_in(user)
		visit franchise_documents_path
		expect(page).to_not have_content(document2.description)
	end
	
end