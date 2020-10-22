require "rails_helper"

RSpec.describe "Requests Admin Insurances", :type => :request do 
  #Create a user and a property tied to that user
  let!(:admin) {create(:admin)} 
  let!(:glass)    {create :franchise, lastname: "Glass", firstname: "Forrest"}
  let!(:glass_insurance) {create :insurance, franchise: glass, other_insurance: 1, other_expiration: Date.today+1.year,other_description: "Description"}
  let!(:kittle)   {create :franchise, lastname: "Kittle", firstname: "Theresa"}
  

  #Tests to access the different enpoints while user not signed in
  describe 'Admin Not Signed In' do 
    
    describe 'GET #index' do
      subject { get admins_insurances_path} 
    
      it_behaves_like 'admin_not_signed_in'

    end

    

    describe 'GET #new' do
      
      subject {get new_admins_insurance_path}

      it_behaves_like 'admin_not_signed_in'

    end

    describe 'GET #edit' do
      
      subject {get edit_admins_insurance_path glass_insurance} 

      it_behaves_like 'admin_not_signed_in'

    end
    
    describe "PATCH #update" do 
      
      subject {patch admins_insurance_path glass_insurance, params: {insurance: attributes_for(:insurance, franchise: glass, other_description: 'New Description')}}

      it "does not update the record in the database" do 
        subject
        expect(glass_insurance.reload.other_description).to_not eq "New Description"
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_admin_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post admins_insurances_path, params: {insurance: FactoryBot.attributes_for(:insurance) }} 
 
      it "does not change the number of Insurance records" do 
        expect {subject}.to_not change {Insurance.count}
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
        get admins_insurances_path
        expect(response).to be_successful
      end
    end

    

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_admins_insurance_path({franchise_id: glass.id})
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        get edit_admins_insurance_path glass_insurance
        expect(response).to be_successful
      end
    end
    describe "PATCH #update" do 
      context "with valid attributes" do 
        let(:changed_attributes) {glass_insurance.attributes.symbolize_keys.merge(other_description: "New Description", eo_expiration: nil, gen_expiration: nil, other_expiration: '01/01/2000'  )}
   
        subject {patch admins_insurance_path glass_insurance, params: {insurance: changed_attributes }}

        it "updates the record in the database" do 
          subject
          
          expect(glass_insurance.reload.other_description).to eq "New Description"
        end

        it "redirects to Insurance index" do 
          subject
          expect(response).to redirect_to admins_insurances_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {glass_insurance.attributes.symbolize_keys.merge(other_insurance: 1,other_description: nil, gen_expiration: nil, other_expiration: '01/01/2000', eo_expiration: nil)}
        subject {patch admins_insurance_path glass_insurance, params: {insurance: changed_attributes}}

        it "does not updates the record in the database" do 
          subject
          expect(glass_insurance.reload.other_description).to_not eq nil
        end

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end
      end
    end

    describe 'POST #create' do 
      
      context "with valid attributes" do
        
        subject {post admins_insurances_path,params: {insurance: FactoryBot.attributes_for(:insurance,franchise_id: kittle.id) }} 
 
        it "creates an Insurance record in the database" do 
          expect {subject}.to change {Insurance.count}.by(1)
        end  

        it "redirects to admin insurances index" do 
          subject
          expect(response).to redirect_to admins_insurances_path
        end
      end

      context "with invalid attributes" do
        
        subject {post admins_insurances_path,params: {insurance: FactoryBot.attributes_for(:insurance, eo_insurance: 1 , eo_expiration: nil, franchise_id: glass.id) }} 
 
        it "does not creates an Insurance record in the database" do 
          expect {subject}.not_to change {Insurance.count}
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
      subject {get insurance_path glass_insurance} 

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