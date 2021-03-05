require "rails_helper"

RSpec.describe "Requests Admin Remittances", :type => :request do 
  #Create an admin and Website preferences
  let!(:admin) {create(:admin)} 
  let!(:fran1)    {create :franchise}
  let!(:fran1_remittance) {create :remittance, :pending, franchise: fran1, month: 2, year: Date.today.year}
  let!(:fran1_posted_remittance) {create :remittance, :posted, franchise: fran1, month: 1 , year: Date.today.year}
  let!(:fran2)   {create :franchise}
  

  #Tests to access the different enpoints while user not signed in
  describe 'Admin Not Signed In' do 
    
    describe 'GET #index' do
      subject { get admins_remittances_path} 
      it_behaves_like 'admin_not_signed_in'
    end

    describe 'GET #new' do
      subject {get new_admins_remittance_path}
      it_behaves_like 'admin_not_signed_in'
    end

    describe 'GET #edit' do
      subject {get edit_admins_remittance_path fran1_remittance} 
      it_behaves_like 'admin_not_signed_in'
    end
    
    describe "PATCH #update" do 
      
      subject {patch admins_remittance_path fran1_remittance, params: {remittance: attributes_for(:remittance, :pending, franchise: fran1, accounting: 999)}}

      it "does not update the record in the database" do 
        subject
        expect(fran1_remittance.reload.accounting).to_not eq(999.00)
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_admin_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post admins_remittances_path, params: {remittance: attributes_for(:remittance, :pending) }} 
 
      it "does not change the number of Remittance records" do 
        expect {subject}.to_not change {Remittance.count}
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
        get admins_remittances_path
        expect(response).to be_successful
      end
    end

    

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_admins_remittance_path({franchise_id: fran1.id})
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        get edit_admins_remittance_path fran1_remittance
        expect(response).to be_successful
      end
    end
    describe "PATCH #update" do 
      context "with valid attributes" do 
        let(:changed_attributes) {fran1_remittance.attributes.symbolize_keys.merge(accounting: 999,  franchise_id: fran1.id, date_received: Date.new(Date.today.year,2,1).strftime("%m/%d/%Y"))}
   
        subject {patch admins_remittance_path fran1_remittance, params: {remittance: changed_attributes,  submit: 'Save for Later' }}

        it "updates the record in the database" do 
          subject
          expect(fran1_remittance.reload.accounting).to eq(changed_attributes[:accounting])
        end

        it "redirects to Remittances index" do 
          subject
          expect(response).to redirect_to admins_remittances_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {fran1_remittance.attributes.symbolize_keys.merge(royalty: -999, franchise_id: fran1.id, date_received: Date.new(Date.today.year,2,1).strftime("%m/%d/%Y"))}
        subject {patch admins_remittance_path fran1_remittance, params: {remittance: changed_attributes, submit: 'Save for Later'}}

        it "does not updates the record in the database" do 
          subject
          expect(fran1_remittance.reload.royalty).to_not eq -999
        end

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end
      end
    end

    describe 'POST #create' do 
      
      context "with valid attributes" do
        
        subject {post admins_remittances_path,params: {remittance: attributes_for(:remittance, status: :pending, franchise_id: fran2.id, date_received: Date.new(Date.today.year,2,1).strftime("%m/%d/%Y")), submit: "Save for Later" }} 
 
        it "creates a Remittance record in the database" do 
          expect {subject}.to change {Remittance.count}.by(1)
        end  

        it "redirects to admin remittances index" do 
          subject
          expect(response).to redirect_to admins_remittances_path
        end
      end

      context "with invalid attributes" do
        
        subject {post admins_remittances_path,params: {remittance: attributes_for(:remittance, status: :pending, franchise_id: fran2.id, royalty: -999, date_received: Date.new(Date.today.year,2,1).strftime("%m/%d/%Y") ), submit: "Save for Later"}} 
 
        it "does not creates a Remittance record in the database" do 
          expect {subject}.not_to change {Remittance.count}
        end  

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end 
      end
    end
  end

end