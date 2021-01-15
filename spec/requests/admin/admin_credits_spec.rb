require "rails_helper"

RSpec.describe "Requests Admin Credits", type: :request do 
  #Create an admin and Website preferences
  let!(:admin) {create(:admin)} 
  let!(:fran1)    {create :franchise}
  let!(:fran2)   {create :franchise}
  let!(:fran1_credit) {create :prp_transaction, :credit, franchise: fran1}

  #Tests to access the different enpoints while user not signed in
  describe 'Admin Not Signed In' do 
    
    describe 'GET #index' do
      subject { get admins_credits_path} 
      it_behaves_like 'admin_not_signed_in'
    end

    describe 'GET #new' do
      subject {get new_admins_credit_path}
      it_behaves_like 'admin_not_signed_in'
    end

    describe 'GET #edit' do
      subject {get edit_admins_credit_path fran1_credit} 
      it_behaves_like 'admin_not_signed_in'
    end
    
    describe "PATCH #update" do 
      
      subject {patch admins_credit_path fran1_credit, params: {prp_transaction: attributes_for(:prp_transaction, :credit, franchise: fran1, date_posted: '01/01/2021', amount: 444.44)}}

      it "does not update the record in the database" do 
        subject
        expect(fran1_credit.reload.amount).to_not eq(444.44)
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_admin_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post admins_credits_path, params: {prp_transaction: attributes_for(:prp_transaction, :credit) }} 
 
      it "does not change the number of Credit records" do 
        expect {subject}.to_not change {PrpTransaction.count}
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
        get admins_credits_path
        expect(response).to be_successful
      end
    end

    

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_admins_credit_path({franchise_id: fran1.id})
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        get edit_admins_credit_path fran1_credit
        expect(response).to be_successful
      end
    end

    describe "PATCH #update" do 
      context "with valid attributes" do 
        let(:changed_attributes) {fran1_credit.attributes.symbolize_keys.merge(amount: 444, date_posted: "02/01/2021",franchise_id: fran1.id )}
   
        subject {patch admins_credit_path fran1_credit, params: {prp_transaction: changed_attributes }}

        it "updates the record in the database" do 
          subject
          expect(fran1_credit.reload.amount).to eq(444)
        end

        it "redirects to Credits index" do 
          subject
          expect(response).to redirect_to admins_credits_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {fran1_credit.attributes.symbolize_keys.merge(date_posted: "02/01/2021",amount: -100)}

        subject {patch admins_credit_path fran1_credit, params: {prp_transaction: changed_attributes}}

        it "does not updates the record in the database" do 
          subject
          expect(fran1_credit.reload.amount).to_not eq -100
        end

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end
      end
    end

    describe 'POST #create' do 
      
      context "with valid attributes" do
        
        subject {post admins_credits_path, params: {prp_transaction: attributes_for(:prp_transaction, :credit, franchise_id: fran2.id, date_posted: "02/01/2021", trans_type: "credit") }} 
 
        it "creates a Credit record in the database" do 
          expect {subject}.to change {PrpTransaction.count}.by(1)
        end  

        it "redirects to admin credits index" do 
          subject
          expect(response).to redirect_to admins_credits_path
        end
      end

      context "with invalid attributes" do
        
        subject {post admins_credits_path, params: {prp_transaction: attributes_for(:prp_transaction, :credit, franchise_id: fran2.id, amount: -100, date_posted: "02/01/2021", trans_type: "credit" )}} 
 
        it "does not creates a Credit record in the database" do 
          expect {subject}.not_to change {PrpTransaction.count}
        end  

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end 
      end
    end
  end

end