require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let!(:glass) {create :franchise, lastname: "Glass"}
  let!(:kittle) {create :franchise, lastname: "Kittle"}
  let!(:invoice1) {create :invoice, franchise: glass}
  let!(:invoice2) {create :invoice, franchise: glass}
  let!(:invoice3) {create :invoice, franchise: glass}
  let!(:invoice4) {create :invoice, :paid, franchise: glass}
  let!(:invoice5) {create :invoice, :paid, franchise: glass}
  let!(:invoice6) {create :invoice, franchise: kittle}
  let!(:invoice7) {create :invoice, franchise: kittle}
  let!(:invoice8) {create :invoice, franchise: kittle}
  let!(:invoice9) {create :invoice, :paid, franchise: kittle}
  let!(:invoice10) {create :invoice, :paid, franchise: kittle}
  
  describe "Test Model validations" do 
	  #Testing validity of the factory
	  it "has a valid factory" do 
	    expect(build(:invoice)).to be_valid
    end

	  it "is invalid without date entered" do  
	    expect(build(:invoice, date_entered: nil )).not_to be_valid
	  end 

  	it "is invalid without note" do  
  	  expect(build(:invoice, note: nil )).not_to be_valid	
    end

    it "is invalid without a paid flag" do 
      expect(build(:invoice, paid: nil)).not_to be_valid
    end


  end

  describe "Testing Scopes" do 
    describe ".all_ordered" do 
      it "should return the proper invoices in proper order" do
        expect(Invoice.all_ordered).to eq([invoice10,invoice9,invoice8,invoice7,invoice6,invoice5, invoice4, invoice3, invoice2, invoice1])
      end
    end
    describe ".all_recent_pending" do 
      it "should return the proper invoice in proper order" do
        expect(Invoice.all_recent_pending).to eq([invoice8,invoice7,invoice6, invoice3, invoice2, invoice1])
      end
    end
    describe ".all_recent_posted" do 
      it "should return the proper invoice in proper order" do
        expect(Invoice.all_recent_posted).to eq([invoice10, invoice9, invoice5, invoice4])
      end
    end
    describe ".all_pending" do 
      it "should return the proper invoice in proper order" do
        expect(Invoice.all_pending).to eq([invoice8, invoice7, invoice6, invoice3, invoice2, invoice1])
      end
    end
    describe ".all_posted" do 
      it "should return the proper invoice in proper order" do
        expect(Invoice.all_posted).to eq([invoice10, invoice9, invoice5, invoice4])        
      end
    end
    describe ".franchise_all" do 
      it "should return the proper invoice in proper order" do
        expect(Invoice.franchise_all(glass)).to eq([invoice5, invoice4, invoice3, invoice2, invoice1])
      end
    end
    describe ".fran_pending" do 
      it "should return the proper invoice in proper order" do
        expect(Invoice.fran_pending(glass)).to eq([invoice3,invoice2,invoice1])
      end
    end
    describe ".fran_posted" do 
      it "should return the proper invoice in proper order" do
        expect(Invoice.fran_posted(kittle)).to eq([invoice10,invoice9])
      end
    end
    describe ".recent_pending" do 
      it "should return the proper invoice in proper order" do
        expect(Invoice.recent_pending(glass)).to eq([invoice3,invoice2,invoice1])
      end
    end
    describe ".recent_posted" do 
      it "should return the proper invoice in proper order" do
        expect(Invoice.fran_posted(kittle)).to eq([invoice10,invoice9])
      end
    end
  end

  describe "Testing methods" do 
    describe "#pending?" do 
      it "should return the proper value" do 
        expect(invoice1.pending?).to eq(true)
        expect(invoice10.pending?).to eq(false)
      end
    end

    describe "#paid?" do 
      it "should return the proper value" do 
        expect(invoice1.paid?).to eq(false)
        expect(invoice10.paid?).to eq(true)
      end
    end
  end
end