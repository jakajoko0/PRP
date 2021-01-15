require 'rails_helper'

RSpec.describe PrpTransaction, type: :model do
  let!(:fran) {create :franchise}
  let!(:credit_code) {create :transaction_code, :credit }
  let!(:charge_code) {create :transaction_code, :charge}
  let!(:credit1) {create :prp_transaction, :credit, trans_code: credit_code.code, franchise: fran}
  let!(:credit2) {create :prp_transaction, :credit, trans_code: credit_code.code, franchise: fran}
  let!(:credit3) {create :prp_transaction, :credit, trans_code: credit_code.code, franchise: fran}
  let!(:charge1) {create :prp_transaction, :charge, trans_code: charge_code.code, franchise: fran}
  let!(:charge2) {create :prp_transaction, :charge, trans_code: charge_code.code, franchise: fran}
  let!(:charge3) {create :prp_transaction, :charge, trans_code: charge_code.code, franchise: fran}


  describe "Test Model validations" do 
	  #Testing validity of the factory
	  it "has a valid factory" do 
	    expect(build(:prp_transaction)).to be_valid
    end

	  it "is invalid without date posted" do  
	    expect(build(:prp_transaction, date_posted: nil )).not_to be_valid
	  end 

  	it "is invalid without trans type" do  
  	  expect(build(:prp_transaction, trans_type: nil )).not_to be_valid	
    end

    it "is invalid without trans code" do  
      expect(build(:prp_transaction, trans_code: nil )).not_to be_valid 
    end

    it "is invalid without valid amount" do  
      expect(build(:prp_transaction, amount: -1.00 )).not_to be_valid 

    end


  end

  describe "Testing Scopes" do 
    describe ".all_credits" do 
      it "should return the proper credits in proper order" do
        expect(PrpTransaction.all_credits).to eq([credit3,credit2,credit1])
      end
    end

    describe ".all_charges" do 
      it "should return the proper charges in proper order" do 
        expect(PrpTransaction.all_charges).to eq([charge3,charge2,charge1])
      end
    end

  end

  

end