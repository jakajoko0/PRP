require "rails_helper"



RSpec.describe "Requests Franchise Remittances", :type => :request do 

  #Create a user and a property tied to that user
  let!(:user) {create(:user)} 
  let!(:user2) {create(:user)}
  let!(:glass)  {user.franchise}
  let!(:kittle) {user2.franchise}
  let!(:glass_remittance) {create :remittance, :pending,  franchise_id: glass.id, month: 1, year: Date.today.year}
  let!(:kittle_remittance) {create :remittance, franchise_id: kittle.id, month: 1, year: Date.today.year}
  
  #Tests to access the different enpoints while user not signed in
  describe 'Franchise Not Signed In' do 
    
    describe 'GET #index' do
      subject { get remittances_path} 
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #new' do
      subject {get new_remittance_path}
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #edit' do
      subject {get edit_remittance_path glass_remittance} 
      it_behaves_like 'franchise_not_signed_in'
    end
    
    describe "PATCH #update" do 
      
      subject {patch remittance_path glass_remittance, params: {remittance: attributes_for(:remittance, franchise_id: glass.id, accounting: 99999)}}

      it "does not update the record in the database" do 
        subject
        expect(glass_remittance.reload.accounting).to_not eq (99999)
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_user_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post remittances_path, params: {remittance: attributes_for(:remittance, :pending, franchise_id: glass.id) }} 
 
      it "does not change the number of Remittance records" do 
        expect {subject}.to_not change {Remittance.count}
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
        get remittances_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_remittance_path
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        get edit_remittance_path glass_remittance
        expect(response).to be_successful
      end
    end
    describe "PATCH #update" do 
      context "with valid attributes" do 

        let(:changed_attributes) {glass_remittance.attributes.symbolize_keys.merge(accounting: 99999)}
        subject {patch remittance_path glass_remittance, params: {remittance: changed_attributes.merge(franchise_id: glass.id) }}
            
        it "updates the record in the database" do 
          subject
          expect(glass_remittance.reload.accounting).to eq(99999)
        end

        it "redirects to Remittance index" do 
          subject
          expect(response).to redirect_to remittances_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {glass_remittance.attributes.symbolize_keys.merge(year: nil, accounting: 9999)}
        subject {patch remittance_path glass_remittance, params: {remittance: changed_attributes.merge(franchise_id: glass.id)}}

        it "does not updates the record in the database" do 
          subject
          expect(glass_remittance.reload.accounting).to_not eq (99999)
        end

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end
      end
    end

    describe 'POST #create' do 
      context "with valid attributes" do
        
        subject {post remittances_path,params: {remittance: attributes_for(:remittance,status: :pending, franchise_id: glass.id, year: Date.today.year+1) }} 
 
        it "creates a Remittance record in the database" do 
          expect {subject}.to change {Remittance.count}.by(1)
        end  

        it "redirects to Remittances index" do 
          subject
          expect(response).to redirect_to remittances_path
        end
      end

      context "with invalid attributes" do
        
        subject {post remittances_path ,params: {remittance: attributes_for(:remittance, status: :pending, franchise_id: glass.id, year: nil) }} 
 
        it "does not creates a Remittance record in the database" do 
          expect {subject}.not_to change {Remittance.count}
        end  

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end 
      end
    end

    describe "Franchise can't access another franchise remittance" do 

      describe 'GET #edit' do
        it "should redirect to root" do 
          get edit_remittance_path kittle_remittance
          expect(response).to redirect_to root_path
        end
      end
    end
  end
 
end