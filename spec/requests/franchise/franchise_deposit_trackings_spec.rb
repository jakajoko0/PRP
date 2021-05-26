require "rails_helper"

RSpec.describe "Requests Franchise Deposits", :type => :request do 

  #Create a user and a property tied to that user
  let!(:user) {create(:user)} 
  let!(:user2) {create(:user)}
  let!(:glass)  {user.franchise}
  let!(:kittle) {user2.franchise}
  let!(:glass_deposit) {create :deposit_tracking,  franchise_id: glass.id,  month: 1, year: Date.today.year}
  let!(:kittle_deposit) {create :deposit_tracking, franchise_id: kittle.id, month: 1, year: Date.today.year}
  
  #Tests to access the different enpoints while user not signed in
  describe 'Franchise Not Signed In' do 
    
    describe 'GET #index' do
      subject { get deposit_trackings_path} 
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #new' do
      subject {get new_deposit_tracking_path}
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #edit' do
      subject {get edit_deposit_tracking_path glass_deposit} 
      it_behaves_like 'franchise_not_signed_in'
    end
    
    describe "PATCH #update" do 
      
      subject {patch deposit_tracking_path glass_deposit, params: {deposit_tracking: attributes_for(:deposit_tracking, franchise_id: glass.id, accounting: 99999)}}

      it "does not update the record in the database" do 
        subject
        expect(glass_deposit.reload.accounting).to_not eq (99999)
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_user_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post deposit_trackings_path, params: {deposit: attributes_for(:deposit_tracking, franchise_id: glass.id) }} 
 
      it "does not change the number of Depsit Tracking records" do 
        expect {subject}.to_not change {DepositTracking.count}
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
        get deposit_trackings_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_deposit_tracking_path
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        get edit_deposit_tracking_path glass_deposit
        expect(response).to be_successful
      end
    end
    describe "PATCH #update" do 
      context "with valid attributes" do 

        let(:changed_attributes) {glass_deposit.attributes.symbolize_keys.merge(accounting: 2000, total_deposit: 15000, deposit_date: Date.today.strftime("%m/%d/%Y"))}
        subject {patch deposit_tracking_path glass_deposit, params: {deposit_tracking: changed_attributes }}
            
        it "updates the record in the database" do 
          subject
          expect(glass_deposit.reload.accounting).to eq(2000)
        end

        it "redirects to Deposit index" do 
          subject
          expect(response).to redirect_to deposit_trackings_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {glass_deposit.attributes.symbolize_keys.merge(accounting: 4000, total_deposit: 99000, deposit_date: Date.today.strftime("%m/%d/%Y"))}
        subject {patch deposit_tracking_path glass_deposit, params: {deposit_tracking: changed_attributes}}

        it "does not updates the record in the database" do 
          subject
          expect(glass_deposit.reload.accounting).to_not eq (4000)
        end

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end
      end
    end

    describe 'POST #create' do 
      context "with valid attributes" do
        
        subject {post deposit_trackings_path, params: {deposit_tracking: attributes_for(:deposit_tracking, franchise_id: glass.id, accounting: 2000, total_deposit: 15000, deposit_date: Date.today.strftime("%m/%d/%Y")) }} 
 
        it "creates a Deposit Tracking record in the database" do 
          expect {subject}.to change {DepositTracking.count}.by(1)
        end  

        it "redirects to Remittances index" do 
          subject
          expect(response).to redirect_to deposit_trackings_path
        end
      end

      context "with invalid attributes" do
        
        subject {post deposit_trackings_path ,params: {deposit_tracking: attributes_for(:deposit_tracking, franchise_id: glass.id, year: nil, deposit_date: Date.today.strftime("%m/%d/%Y")) }} 
 
        it "does not creates a Deposit record in the database" do 
          expect {subject}.not_to change {DepositTracking.count}
        end  

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end 
      end
    end

    describe "Franchise can't access another franchise deposit" do 

      describe 'GET #edit' do
        it "should redirect to root" do 
          get edit_deposit_tracking_path kittle_deposit
          expect(response).to redirect_to root_path
        end
      end
    end
  end
 
end