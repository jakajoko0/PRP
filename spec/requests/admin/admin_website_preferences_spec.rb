require "rails_helper"

RSpec.describe "Requests Admin Website Preferences", :type => :request do 
  #Create an admin and Website preferences
  let!(:admin) {create(:admin)} 
  let!(:fran1)    {create :franchise}
  let!(:fran1_website_pref) {create :website_preference, :ach, website_preference: 0, franchise: fran1}
  let!(:fran2)   {create :franchise}
  

  #Tests to access the different enpoints while user not signed in
  describe 'Admin Not Signed In' do 
    
    describe 'GET #index' do
      subject { get admins_website_preferences_path} 
    
      it_behaves_like 'admin_not_signed_in'

    end

    

    describe 'GET #new' do
      
      subject {get new_admins_website_preference_path}

      it_behaves_like 'admin_not_signed_in'

    end

    describe 'GET #edit' do
      
      subject {get edit_admins_website_preference_path fran1_website_pref} 

      it_behaves_like 'admin_not_signed_in'

    end
    
    describe "PATCH #update" do 
      
      subject {patch admins_website_preference_path fran1_website_pref, params: {website_preference: attributes_for(:website_preference, :ach, franchise: fran1, website_preference: 2)}}

      it "does not update the record in the database" do 
        subject
        expect(fran1_website_pref.reload.website_preference).to_not eq(2)
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_admin_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post admins_website_preferences_path, params: {website_preference: attributes_for(:website_preference, :ach) }} 
 
      it "does not change the number of Website Preference records" do 
        expect {subject}.to_not change {WebsitePreference.count}
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
        get admins_website_preferences_path
        expect(response).to be_successful
      end
    end

    

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_admins_website_preference_path({franchise_id: fran1.id})
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        get edit_admins_website_preference_path fran1_website_pref
        expect(response).to be_successful
      end
    end
    describe "PATCH #update" do 
      context "with valid attributes" do 
        let(:changed_attributes) {fran1_website_pref.attributes.symbolize_keys.merge(website_preference: 2, bank_token: fran1_website_pref.bank_token,  franchise_id: fran1.id )}
   
        subject {patch admins_website_preference_path fran1_website_pref, params: {website_preference: changed_attributes }}

        it "updates the record in the database" do 
          subject
          expect(fran1_website_pref.reload.website_preference).to eq(2)
        end

        it "redirects to Website Preferences index" do 
          subject
          expect(response).to redirect_to admins_website_preferences_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {fran1_website_pref.attributes.symbolize_keys.merge(website_preference: 2, payment_method: 'ach', bank_token: nil)}
        subject {patch admins_website_preference_path fran1_website_pref, params: {website_preference: changed_attributes}}

        it "does not updates the record in the database" do 
          subject
          expect(fran1_website_pref.reload.payment_token).to_not eq nil
          expect(fran1_website_pref.reload.website_preference).to_not eq 2
        end

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end
      end
    end

    describe 'POST #create' do 
      
      context "with valid attributes" do
        
        subject {post admins_website_preferences_path,params: {website_preference: attributes_for(:website_preference, :ach, franchise_id: fran2.id) }} 
 
        it "creates an Website Preference record in the database" do 
          expect {subject}.to change {WebsitePreference.count}.by(1)
        end  

        it "redirects to admin website preferences index" do 
          subject
          expect(response).to redirect_to admins_website_preferences_path
        end
      end

      context "with invalid attributes" do
        
        subject {post admins_website_preferences_path,params: {website_preference: attributes_for(:website_preference, franchise_id: fran1.id )}} 
 
        it "does not creates an Website Preference record in the database" do 
          expect {subject}.not_to change {WebsitePreference.count}
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
      subject {get website_preference_path fran1_website_pref} 

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