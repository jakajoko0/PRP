require 'rails_helper'

RSpec.describe BankAccount, type: :model do 
  let!(:fran) {create :franchise}
  let!(:checking)    {create :bank_account, franchise: fran}
  let!(:savings)   {create :bank_account, :savings,  franchise: fran}
    

  describe "Test Model validations" do 
	  #Testing validity of the factory
	  it "has a valid factory" do 
	    expect(build(:bank_account)).to be_valid
    end

	  it "is invalid without franchide_id" do  
	    expect(build(:bank_account, franchise: nil)).not_to be_valid
	  end 

  	it "is invalid without routing" do  
  	  expect(build(:bank_account, routing: nil)).not_to be_valid	
    end

    it "is invalid without account number" do
      expect(build(:bank_account, account_number: nil)).not_to be_valid  
    end

    it "is invalid without type of account" do  
      expect(build(:bank_account, type_of_account: nil )).not_to be_valid  
      expect(build(:bank_account, type_of_account: nil )).not_to be_valid  

    end

    it "is invalid without name on the account" do  
      expect(build(:bank_account, name_on_account: nil)).not_to be_valid  
    end

    it "is invalid without proper routing format" do  
      expect(build(:bank_account, routing: '123455556')).not_to be_valid  
    end


  end

  describe "Test the instance methods" do
    describe "#bank_name_and_number" do 
      it "should return the proper value" do 
        expect(checking.bank_name_and_number).to eq("#{checking.bank_name} #{checking.account_type.capitalize} ending in #{checking.last_four}")
      end
    end

    describe "#franchise_name_bank_lastfour" do 
      it "should return the proper value" do 
        expect(checking.franchise_name_bank_lastfour).to eq([checking.franchise&.number_and_name, checking.bank_name, checking.last_four].join("-"))
      end
    end

    describe "#token_type" do
      it "should return the proper value" do 
        expect(checking.token_type).to eq("C")
        expect(savings.token_type).to eq("S")
      end
    end
  end
end