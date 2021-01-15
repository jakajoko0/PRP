require 'rails_helper'

RSpec.feature "Feature - Viewing Charges", type: :feature do 
  let!(:admin) {create(:admin)}	
  let!(:fran) {create(:franchise)}
  let!(:fran2) {create(:franchise)}
  let!(:charge_fran) {create(:prp_transaction, :charge, franchise_id: fran.id)}

  
  scenario "Admin User Can view all Charges" do 
    visit '/'
    simulate_admin_sign_in(admin)
    visit admins_charges_path
    expect(page).to have_content(charge_fran.trans_description)
  end
end
