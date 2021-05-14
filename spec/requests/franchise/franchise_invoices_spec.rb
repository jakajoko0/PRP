require "rails_helper"



RSpec.describe "Requests Franchise Invoices", :type => :request do 

  #Create a user and a property tied to that user
  let!(:user) {create(:user)} 
  let!(:user2) {create(:user)}
  let!(:glass)  {user.franchise}
  let!(:kittle) {user2.franchise}
  let!(:glass_invoice) {create :invoice, franchise_id: glass.id}
  let!(:kittle_invoice) {create :invoice, franchise_id: kittle.id}
  let!(:glass_detail) {create :invoice_item, invoice: glass_invoice}
  #Tests to access the different enpoints while user not signed in
  describe 'Franchise Not Signed In' do 
    
    describe 'GET #index' do
      subject { get invoices_path} 
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #new' do
      subject {get new_invoice_path}
      it_behaves_like 'franchise_not_signed_in'
    end

    describe 'GET #edit' do
      subject {get edit_invoice_path glass_invoice} 
      it_behaves_like 'franchise_not_signed_in'
    end
    
    describe "PATCH #update" do 
      
      subject {patch invoice_path glass_invoice, params: {financial: attributes_for(:invoice, franchise_id: glass.id, note: "My Note")}}

      it "does not update the record in the database" do 
        subject
        expect(glass_invoice.reload.note).to_not eq ("My Note")
      end

      it "redirects to sign in page" do 
        subject
        expect(response).to redirect_to (new_user_session_path)
      end
    end


    describe "POST #create" do
      
      subject {post invoices_path, params: {invoice: attributes_for(:invoice) }} 
 
      it "does not change the number of Invoice records" do 
        expect {subject}.to_not change {Invoice.count}
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
        get invoices_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it "returns a successful response" do 
        get new_invoice_path
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do 
      it "returns a successful response" do 
        get edit_invoice_path glass_invoice
        expect(response).to be_successful
      end
    end
    describe "PATCH #update" do 
      context "with valid attributes" do 

        let(:changed_attributes) {glass_invoice.attributes.symbolize_keys.merge(note: "My New Note",date_entered: Date.new(Date.today.year,1,1).strftime("%m/%d/%Y"))}
        subject {patch invoice_path glass_invoice, params: {invoice: changed_attributes.merge(franchise_id: glass.id) }}
            
        it "updates the record in the database" do 
          subject
          expect(glass_invoice.reload.note).to eq(changed_attributes[:note])
        end

        it "redirects to Invoice index" do 
          subject
          expect(response).to redirect_to invoices_path
        end
      end

      context "with invalid attributes" do
        let(:changed_attributes) {glass_invoice.attributes.symbolize_keys.merge(note: nil, date_entered: Date.new(Date.today.year,1,1).strftime("%m/%d/%Y"))}
        subject {patch invoice_path glass_invoice, params: {invoice: changed_attributes.merge(franchise_id: glass.id)}}

        it "does not updates the record in the database" do 
          subject
          expect(glass_invoice.reload.note).to_not eq (changed_attributes[:note])
        end

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end
      end
    end

    describe 'POST #create' do 
      context "with valid attributes" do
        subject {post invoices_path,params: {invoice: attributes_for(:invoice, franchise_id: glass.id, date_entered: Date.new(Date.today.year,1,1).strftime("%m/%d/%Y"),invoice_items_attributes: [attributes_for(:invoice_item, amount: 1000)]) }} 
 
        it "creates an Invoice record in the database" do 
          expect {subject}.to change {Invoice.count}.by(1)
          .and change {InvoiceItem.count}.by(1)
        end  

        it "redirects to Invoices index" do 
          subject
          expect(response).to redirect_to invoices_path
        end
      end

      context "with invalid attributes" do
        
        subject {post invoices_path ,params: {invoice: attributes_for(:invoice, franchise_id: glass.id, note: nil, date_entered: Date.new(Date.today.year,1,1).strftime("%m/%d/%Y")) }} 
 
        it "does not creates an Invoice record in the database" do 
          expect {subject}.not_to change {Invoice.count}
        end  

        it "returns a successful response" do 
          subject
          expect(response).to be_successful
        end 
      end
    end

    describe "Franchise can't access another franchise invoice" do 

      describe 'GET #edit' do
        it "should redirect to root" do 
          get edit_invoice_path kittle_invoice
          expect(response).to redirect_to root_path
        end
      end
    end
  end
 
end