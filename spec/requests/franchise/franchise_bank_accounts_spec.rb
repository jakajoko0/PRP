require "rails_helper"
require "savon/mock/spec_helper"


RSpec.describe "Requests Franchise Bank Accounts", :type => :request do 
  include Savon::SpecHelper
  #Create a user and a property tied to that user
  before(:all) {savon.mock!}
  after(:all) {savon.unmock!}
  let!(:user) {create(:user)} 
  let!(:user2) {create(:user)}
  let!(:glass)    {user.franchise}
  let!(:kittle) {user2.franchise}
  let!(:glass_account) {create :bank_account, franchise_id: glass.id}
  let!(:kittle_account) {create :bank_account, franchise_id: kittle.id}
  let!(:sys_check) {File.read("spec/factories/gulf/system_check.xml")}
  let!(:token_out) {File.read("spec/factories/gulf/token_output.xml")}
  let!(:token_out_err) {File.read("spec/factories/gulf/token_output_error.xml")}
  let!(:token_in) {File.read("spec/factories/gulf/token_input.xml")}

  #Tests to access the different enpoints while user not signed in
  describe 'Franchise Not Signed In' do 
    
    describe 'GET #index' do
      subject { get bank_accounts_path} 
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #new' do
      subject {get new_bank_account_path}
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #edit' do
      subject {get edit_bank_account_path glass_account} 
      it_behaves_like 'franchise_not_signed_in'
    end
    
    describe "PATCH #update" do 
      
      subject {patch bank_account_path glass_account, params: {bank_account: attributes_for(:bank_account_create, franchise: glass, account_number: "111111111")}}

      it "does not update the record in the database" do 
        subject
        expect(glass_account.reload.last_four).to_not eq "1111"
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_user_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post bank_accounts_path, params: {bank_account: attributes_for(:bank_account_create) }} 
 
      it "does not change the number of Bank Account records" do 
        expect {subject}.to_not change {BankAccount.count}
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
        get bank_accounts_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_bank_account_path
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        savon.expects(:system_check).with(message: :any).returns(sys_check)
        savon.expects(:token_output).with(message: :any).returns(token_out)
        get edit_bank_account_path glass_account
        expect(response).to be_successful
      end
    end
    describe "PATCH #update" do 
      context "with valid attributes" do 

        before do 
          savon.expects(:system_check).with(message: :any).returns(sys_check)
          savon.expects(:token_input).with(message: :any).returns(token_in)
        end
        
        let(:changed_attributes) {glass_account.attributes.symbolize_keys.merge(attributes_for(:bank_account_create))}
        subject {patch bank_account_path glass_account, params: {bank_account: changed_attributes.merge(franchise_id: glass.id) }}
            
        it "updates the record in the database" do 
          subject
          expect(glass_account.reload.last_four).to eq "6789"
        end

        it "redirects to Bank Account index" do 
          subject
          expect(response).to redirect_to bank_accounts_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {glass_account.attributes.symbolize_keys.merge(attributes_for(:bank_account_create).merge(routing: "111111111"))}
        subject {patch bank_account_path glass_account, params: {bank_account: changed_attributes.merge(franchise_id: glass.id)}}

        it "does not updates the record in the database" do 
          subject
          expect(glass_account.reload.last_four).to_not eq "6789"
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
        
        subject {post bank_accounts_path,params: {bank_account: attributes_for(:bank_account_create,franchise_id: glass.id) }} 
 
        it "creates a Bank Account record in the database" do 
          expect {subject}.to change {BankAccount.count}.by(1)
        end  

        it "redirects to Bank Account index" do 
          subject
          expect(response).to redirect_to bank_accounts_path
        end
      end

      context "with invalid attributes" do
        
        subject {post bank_accounts_path ,params: {bank_account: attributes_for(:bank_account_create, franchise_id: glass.id, routing: '111111111') }} 
 
        it "does not creates an Bank Account record in the database" do 
          expect {subject}.not_to change {BankAccount.count}
        end  

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end 
      end
    end

    describe "Franchise can't access another franchise bank accounts" do 

      describe 'GET #edit' do
        it "should redirect to root" do 
          get edit_bank_account_path kittle_account
          expect(response).to redirect_to root_path
        end
      end
    end
  end
 
end