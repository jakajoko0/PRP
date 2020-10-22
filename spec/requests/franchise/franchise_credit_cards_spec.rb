require "rails_helper"
require "savon/mock/spec_helper"


RSpec.describe "Requests Franchise Credit Card", :type => :request do 
  include Savon::SpecHelper
  #Create a user and a property tied to that user
  before(:all) {savon.mock!}
  after(:all) {savon.unmock!}
  let!(:user) {create(:user)} 
  let!(:user2) {create(:user)}
  let!(:glass)    {user.franchise}
  let!(:kittle) {user2.franchise}
  let!(:glass_card) {create :credit_card, franchise_id: glass.id}
  let!(:kittle_card) {create :credit_card, franchise_id: kittle.id}
  let!(:sys_check) {File.read("spec/factories/gulf/system_check.xml")}
  let!(:token_out) {File.read("spec/factories/gulf/token_output_cc.xml")}
  let!(:token_out_err) {File.read("spec/factories/gulf/token_output_error.xml")}
  let!(:token_in) {File.read("spec/factories/gulf/token_input_cc.xml")}

  #Tests to access the different enpoints while user not signed in
  describe 'Franchise Not Signed In' do 
    
    describe 'GET #index' do
      subject { get credit_cards_path} 
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #new' do
      subject {get new_credit_card_path}
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #edit' do
      subject {get edit_credit_card_path glass_card} 
      it_behaves_like 'franchise_not_signed_in'
    end
    
    describe "PATCH #update" do 
      
      subject {patch credit_card_path glass_card, params: {credit_card: attributes_for(:credit_card_create, franchise: glass, cc_number: "4111111111111111")}}

      it "does not update the record in the database" do 
        subject
        expect(glass_card.reload.last_four).to_not eq "1111"
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_user_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post credit_cards_path, params: {credit_card: attributes_for(:credit_card_create) }} 
 
      it "does not change the number of Credit Card records" do 
        expect {subject}.to_not change {CreditCard.count}
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
        get credit_cards_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_credit_card_path
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        savon.expects(:system_check).with(message: :any).returns(sys_check)
        savon.expects(:token_output).with(message: :any).returns(token_out)
        get edit_credit_card_path glass_card
        expect(response).to be_successful
      end
    end
    describe "PATCH #update" do 
      context "with valid attributes" do 

        before do 
          savon.expects(:system_check).with(message: :any).returns(sys_check)
          savon.expects(:token_input).with(message: :any).returns(token_in)
        end
        
        let(:changed_attributes) {glass_card.attributes.symbolize_keys.merge(attributes_for(:credit_card_create))}
        subject {patch credit_card_path glass_card, params: {credit_card: changed_attributes.merge(franchise_id: glass.id) }}
            
        it "updates the record in the database" do 
          subject
          expect(glass_card.reload.last_four).to eq "1111"
        end

        it "redirects to Credit Cards index" do 
          subject
          expect(response).to redirect_to credit_cards_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {glass_card.attributes.symbolize_keys.merge(attributes_for(:credit_card_create).merge(cc_number: nil))}
        subject {patch credit_card_path glass_card, params: {credit_card: changed_attributes.merge(franchise_id: glass.id)}}

        it "does not updates the record in the database" do 
          subject
          expect(glass_card.reload.last_four).to_not eq "1111"
        end

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end
      end
    end

    describe 'POST #create' do 
      context "with valid attributes" do

        before do 
          savon.expects(:system_check).with(message: :any).returns(sys_check)
          savon.expects(:token_input).with(message: :any).returns(token_in)
        end
        
        subject {post credit_cards_path,params: {credit_card: attributes_for(:credit_card_create,franchise_id: glass.id) }} 
 
        it "creates a Credit Card record in the database" do 
          expect {subject}.to change {CreditCard.count}.by(1)
        end  

        it "redirects to Credit Cards index" do 
          subject
          expect(response).to redirect_to credit_cards_path
        end
      end

      context "with invalid attributes" do
        
        subject {post credit_cards_path ,params: {credit_card: attributes_for(:credit_card_create, franchise_id: glass.id, cc_number: nil) }} 
 
        it "does not creates a Credit Card record in the database" do 
          expect {subject}.not_to change {CreditCard.count}
        end  

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end 
      end
    end

    describe "Franchise can't access another franchise credit cards" do 

      describe 'GET #edit' do
        it "should redirect to root" do 
          get edit_credit_card_path kittle_card
          expect(response).to redirect_to root_path
        end
      end
    end
  end
 
end