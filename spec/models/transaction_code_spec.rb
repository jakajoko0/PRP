require 'rails_helper'

RSpec.describe TransactionCode, type: :model do 
  let!(:trans_code) {create :transaction_code}
  let!(:trans_code2) {create :transaction_code}

  describe "Test Model validations" do 
	  #Testing validity of the factory
	  it "has a valid factory" do 
	    expect(build(:transaction_code)).to be_valid
    end

	  it "is invalid without code" do  
	    expect(build(:transaction_code, code: nil )).not_to be_valid
	  end 

  	it "is invalid without description" do  
  	  expect(build(:transaction_code, description: nil )).not_to be_valid	
    end

    it "is invalid without trans type" do  
      expect(build(:transaction_code, trans_type: nil )).not_to be_valid 
    end

    it "is invalid without royalties flag" do  
      expect(build(:transaction_code, show_in_royalties: nil )).not_to be_valid 
    end

    it "is invalid without invoicing flag" do  
      expect(build(:transaction_code, show_in_invoicing: nil )).not_to be_valid 

    end

    it "does not accept duplicate code" do 
      expect(build(:transaction_code, code: trans_code.code)).not_to be_valid
    end

  end

  
  describe "Testing class methods" do 
    describe ".description_from_code" do 
      it "should return the proper description" do 
        expect(TransactionCode.description_from_code(trans_code.code)).to eq(trans_code.description)
        expect(TransactionCode.description_from_code(trans_code2.code)).to eq(trans_code2.description)
      end
    end

    describe ".description_from_id" do 
      it "should return the proper description" do 
        expect(TransactionCode.description_from_id(trans_code.id)).to eq(trans_code.description)
        expect(TransactionCode.description_from_id(trans_code2.id)).to eq(trans_code2.description)
      end
    end
  end

end