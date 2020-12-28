require "rails_helper"



RSpec.describe "Requests Franchise Financials", :type => :request do 

  #Create a user and a property tied to that user
  let!(:user) {create(:user)} 
  let!(:user2) {create(:user)}
  let!(:glass)  {user.franchise}
  let!(:kittle) {user2.franchise}
  let!(:glass_financial) {create :financial, franchise_id: glass.id}
  let!(:kittle_financial) {create :financial, franchise_id: kittle.id}
  
  #Tests to access the different enpoints while user not signed in
  describe 'Franchise Not Signed In' do 
    
    describe 'GET #index' do
      subject { get financials_path} 
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #new' do
      subject {get new_financial_path}
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #edit' do
      subject {get edit_financial_path glass_financial} 
      it_behaves_like 'franchise_not_signed_in'
    end
    
    describe "PATCH #update" do 
      
      subject {patch financial_path glass_financial, params: {financial: attributes_for(:financial, franchise_id: glass.id, acct_monthly: 99999)}}

      it "does not update the record in the database" do 
        subject
        expect(glass_financial.reload.acct_monthly).to_not eq (99999)
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_user_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post financials_path, params: {financial: attributes_for(:financial) }} 
 
      it "does not change the number of Financial records" do 
        expect {subject}.to_not change {Financial.count}
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_user_session_path)
      end
    end

    
  end  

  #Tests to access the different enpoints while used signed in
  describe 'Franchise Signed In' do 
    before do 
      sign_in user
    end
    
    describe 'GET #index' do 
      it "returns a successful response" do 
        get financials_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_financial_path
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        get edit_financial_path glass_financial
        expect(response).to be_successful
      end
    end
    describe "PATCH #update" do 
      context "with valid attributes" do 

        let(:changed_attributes) {glass_financial.attributes.symbolize_keys.merge(acct_monthly: 99999)}
        subject {patch financial_path glass_financial, params: {financial: changed_attributes.merge(franchise_id: glass.id) }}
            
        it "updates the record in the database" do 
          subject
          expect(glass_financial.reload.acct_monthly).to eq(99999)
        end

        it "redirects to Financial index" do 
          subject
          expect(response).to redirect_to financials_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {glass_financial.attributes.symbolize_keys.merge(year: nil, acct_monthly: 99999)}
        subject {patch financial_path glass_financial, params: {financial: changed_attributes.merge(franchise_id: glass.id)}}

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
        
        subject {post financials_path,params: {financial: attributes_for(:financial,franchise_id: glass.id, year: Date.today.year+1) }} 
 
        it "creates a Financial record in the database" do 
          expect {subject}.to change {Financial.count}.by(1)
        end  

        it "redirects to Financials index" do 
          subject
          expect(response).to redirect_to financials_path
        end
      end

      context "with invalid attributes" do
        
        subject {post financials_path ,params: {financial: attributes_for(:financial, franchise_id: glass.id, year: nil) }} 
 
        it "does not creates an Financial record in the database" do 
          expect {subject}.not_to change {Financial.count}
        end  

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end 
      end
    end

    describe "Franchise can't access another franchise financials" do 

      describe 'GET #edit' do
        it "should redirect to root" do 
          get edit_financial_path kittle_financial
          expect(response).to redirect_to root_path
        end
      end
    end
  end
 
end