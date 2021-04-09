require "rails_helper"

RSpec.describe "Requests Admin Franchise Documents", type: :request do 
  #Create a user and a property tied to that user
  let!(:admin) {create(:admin)} 
  let!(:glass) {create :franchise}
  let!(:kittle) {create :franchise}
  let!(:glass_document) {create :franchise_document, franchise_id: glass.id}
  let!(:kittle_document) {create :franchise_document, franchise_id: kittle.id}

  #Tests to access the different enpoints while user not signed in
  describe 'Admin Not Signed In' do 
    
    describe 'GET #index' do
      subject { get admins_franchise_documents_path} 

      it_behaves_like 'admin_not_signed_in'
    
    end

    

    describe 'GET #new' do
      
      subject {get new_admins_franchise_document_path}

      it_behaves_like 'admin_not_signed_in'

    end

    describe 'GET #edit' do
      
      subject {get edit_admins_franchise_document_path glass_document} 

      it_behaves_like 'admin_not_signed_in'

    end
    
    describe "PATCH #update" do 
      
      subject {patch admins_franchise_document_path glass_document, params: {franchise_document: attributes_for(:franchise_document, franchise: glass,  description: "Document Description")}}

      it "does not update the record in the database" do 
        subject
        expect(glass_document.reload.description).to_not eq "Document Description"
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_admin_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post admins_franchise_documents_path, params: {franchise_document: FactoryBot.attributes_for(:franchise_document) }} 
 
      it "does not change the number of Franchise Documents" do 
        expect {subject}.to_not change {FranchiseDocument.count}
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
        get admins_franchise_documents_path
        expect(response).to be_successful
      end
    end

    

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_admins_franchise_document_path({franchise_id: glass.id})
        expect(response).to be_successful
      end
    end

    
    describe 'POST #create' do 
      
      context "with valid attributes" do
        
        subject {post admins_franchise_documents_path, params: {franchise_document: FactoryBot.attributes_for(:franchise_document, franchise_id: glass.id) }} 
 
        it "creates an Franchise Document in the database" do 
          expect {subject}.to change {FranchiseDocument.count}.by(1)
        end  

        it "redirects to admin franchise document index" do 
          subject
          expect(response).to redirect_to admins_franchise_documents_path
        end
      end

      context "with invalid attributes" do
        
        subject {post admins_franchise_documents_path,params: {franchise_document: FactoryBot.attributes_for(:franchise_document, description: nil, franchise_id: glass.id) }} 
 
        it "does not creates an Franchise Document in the database" do 
          expect {subject}.not_to change {FranchiseDocument.count}
        end  

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end 
      end
    end
  end


 
end