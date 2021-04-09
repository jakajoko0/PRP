require "rails_helper"

RSpec.describe "Requests Franchise Documents", type: :request do 

  #Create a user and a property tied to that user
  let!(:user) {create(:user)} 
  let!(:user2) {create(:user)}
  let!(:glass)  {user.franchise}
  let!(:kittle) {user2.franchise}
  let!(:glass_document) {create :franchise_document, franchise_id: glass.id}
  let!(:kittle_document) {create :franchise_document, franchise_id: kittle.id}
  
  #Tests to access the different enpoints while user not signed in
  describe 'Franchise Not Signed In' do 
    
    describe 'GET #index' do
      subject { get franchise_documents_path} 
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #new' do
      subject {get new_franchise_document_path}
      it_behaves_like 'franchise_not_signed_in'
    end


    describe "POST #create" do
      subject {post franchise_documents_path, params: {franchise_document: attributes_for(:franchise_document) }} 
      it "does not change the number of Franchise document records" do 
        expect {subject}.to_not change {FranchiseDocument.count}
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
        get franchise_documents_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_franchise_document_path
        expect(response).to be_successful
      end
    end


    describe 'POST #create' do 
      context "with valid attributes" do
        
        subject {post franchise_documents_path,params: {franchise_document: attributes_for(:franchise_document,franchise_id: glass.id) }} 
 
        it "creates a Franchise Document record in the database" do 
          expect {subject}.to change {FranchiseDocument.count}.by(1)
        end  

        it "redirects to Franchise Document index" do 
          subject
          expect(response).to redirect_to franchise_documents_path
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
  end
end