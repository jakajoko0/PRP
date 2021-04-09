require "rails_helper"

RSpec.describe "Requests Admin Franchise Financials", type: :request do 
  #Create a user and a property tied to that user
  let!(:admin) {create(:admin)} 
  let!(:glass) {create :franchise}
  let!(:kittle) {create :franchise}
  let!(:glass_financial) {create :financial, franchise_id: glass.id}
  let!(:kittle_financial) {create :financial, franchise_id: kittle.id}

  #Tests to access the different enpoints while user not signed in
  describe 'Admin Not Signed In' do 
    
    describe 'GET #index' do
      subject { get admins_financials_path} 

      it_behaves_like 'admin_not_signed_in'
    
    end

    

    describe 'GET #new' do
      
      subject {get new_admins_financial_path}

      it_behaves_like 'admin_not_signed_in'

    end

    describe 'GET #edit' do
      
      subject {get edit_admins_financial_path glass_financial} 

      it_behaves_like 'admin_not_signed_in'

    end
    
    describe "PATCH #update" do 
      
      subject {patch admins_financial_path glass_financial, params: {financial: attributes_for(:financial, franchise: glass,  acct_monthly: 99999)}}

      it "does not update the record in the database" do 
        subject
        expect(glass_financial.reload.acct_monthly).to_not eq (99999)
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_admin_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post admins_financials_path, params: {financial: FactoryBot.attributes_for(:financial) }} 
 
      it "does not change the number of Financial Reports" do 
        expect {subject}.to_not change {Financial.count}
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_admin_session_path)
      end
    end

    
  end  

  #Tests to access the different enpoints while used signed in
  describe 'Admin Signed In' do 
    before do 
      sign_in admin
    end
    
    describe 'GET #index' do 
      it "returns a successful response" do 
        get admins_financials_path
        expect(response).to be_successful
      end
    end

    

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_admins_financial_path({franchise_id: glass.id})
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        get edit_admins_financial_path glass_financial
        expect(response).to be_successful
      end
    end
    describe "PATCH #update" do 
      context "with valid attributes" do 
        let(:changed_attributes) {glass_financial.attributes.symbolize_keys.merge(acct_monthly: 99999)}
   
        subject {patch admins_financial_path glass_financial, params: {financial: changed_attributes }}

        it "updates the record in the database" do 
          subject
          expect(glass_financial.reload.acct_monthly).to eq (99999)
        end

        it "redirects to Financials index" do 
          subject
          expect(response).to redirect_to admins_financials_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {glass_financial.attributes.symbolize_keys.merge(year: nil, acct_monthly: 99999)}
        subject {patch admins_financial_path glass_financial, params: {financial: changed_attributes}}

        it "does not updates the record in the database" do 
          subject
          expect(glass_financial.reload.acct_monthly).to_not eq (99999)
        end

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end
      end
    end

    describe 'POST #create' do 
      
      context "with valid attributes" do
        
        subject {post admins_financials_path,params: {financial: FactoryBot.attributes_for(:financial, franchise_id: glass.id, year: Date.today.year+1) }} 
 
        it "creates a Financial in the database" do 
          expect {subject}.to change {Financial.count}.by(1)
        end  

        it "redirects to admin financials index" do 
          subject
          expect(response).to redirect_to admins_financials_path
        end
      end

      context "with invalid attributes" do
        
        subject {post admins_financials_path,params: {financial: FactoryBot.attributes_for(:financial, year: nil, acct_monthly: 99999, franchise_id: glass.id) }} 
 
        it "does not creates a Financial in the database" do 
          expect {subject}.not_to change {Financial.count}
        end  

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end 
      end
    end
  end

  describe "Admin don't have access to user pages" do 

    describe 'GET #show' do
      subject {get accountant_path glass} 

      it "returns an unsuccessful response" do 
        subject
        expect(response).to_not be_successful
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_user_session_path)
      end
    end


  end
 
end