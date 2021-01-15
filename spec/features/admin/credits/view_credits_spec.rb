require 'rails_helper'

RSpec.feature "Feature - Viewing Credits", type: :feature do 
  let!(:admin) {create(:admin)}	
  let!(:fran) {create(:franchise)}
  let!(:fran2) {create(:franchise)}
  let!(:credit_fran) {create(:prp_transaction, :credit, franchise_id: fran.id)}

  
  scenario "Admin User Can view all Credits" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_credits_path
    expect(page).to have_content(credit_fran.trans_description)
  end
end
