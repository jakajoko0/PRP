require "rails_helper"

RSpec.describe "Requests Admin Transaction Codes", :type => :request do 
  #Create a user
  let!(:admin) {create(:admin)} 
  let!(:trans_code) {create(:transaction_code)}
  
  

  #Tests to access the different enpoints while user not signed in
  describe 'Admin Not Signed In' do 
    
    describe 'GET #index' do
      subject { get admins_transaction_codes_path} 
    
      it_behaves_like 'admin_not_signed_in'

    end

    

    describe 'GET #new' do
      
      subject {get new_admins_transaction_code_path}

      it_behaves_like 'admin_not_signed_in'

    end

    describe 'GET #edit' do
      
      subject {get edit_admins_transaction_code_path trans_code} 

      it_behaves_like 'admin_not_signed_in'

    end
    
    describe "PATCH #update" do 
      
      subject {patch admins_transaction_code_path trans_code, params: {transaction_code: attributes_for(:transaction_code, description: 'New Description')}}

      it "does not update the record in the database" do 
        subject
        expect(trans_code.reload.description).to_not eq "New Description"
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_admin_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post admins_transaction_codes_path, params: {transaction_code: attributes_for(:transaction_code) }} 
 
      it "does not change the number of Transaction Code records" do 
        expect {subject}.to_not change {TransactionCode.count}
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
        get admins_transaction_codes_path
        expect(response).to be_successful
      end
    end

    

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_admins_transaction_code_path
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        get edit_admins_transaction_code_path trans_code
        expect(response).to be_successful
      end
    end
    describe "PATCH #update" do 
      context "with valid attributes" do 
        let(:changed_attributes) {trans_code.attributes.symbolize_keys.merge(description: "New Description")}
   
        subject {patch admins_transaction_code_path trans_code, params: {transaction_code: changed_attributes }}

        it "updates the record in the database" do 
          subject
          
          expect(trans_code.reload.description).to eq "New Description"
        end

        it "redirects to Transaction Codes index" do 
          subject
          expect(response).to redirect_to admins_transaction_codes_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {trans_code.attributes.symbolize_keys.merge(description: nil)}
        subject {patch admins_transaction_code_path trans_code, params: {transaction_code: changed_attributes}}

        it "does not updates the record in the database" do 
          subject
          expect(trans_code.reload.description).to_not eq nil
        end

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end
      end
    end

    describe 'POST #create' do 
      
      context "with valid attributes" do
        
        subject {post admins_transaction_codes_path,params: {transaction_code: attributes_for(:transaction_code)}} 
 
        it "creates a Transaction Code record in the database" do 
          expect {subject}.to change {TransactionCode.count}.by(1)
        end  

        it "redirects to admin transaction codes index" do 
          subject
          expect(response).to redirect_to admins_transaction_codes_path
        end
      end

      context "with invalid attributes" do
        
        subject {post admins_transaction_codes_path,params: {transaction_code: attributes_for(:transaction_code, description: nil) }} 
 
        it "does not creates a Transaction Record in the database" do 
          expect {subject}.not_to change {TransactionCode.count}
        end  

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end 
      end
    end
  end

  
 
end