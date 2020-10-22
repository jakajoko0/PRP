require 'rails_helper'

RSpec.describe CreditCard, type: :model do 
  let!(:fran) {create :franchise}
  let!(:visa) {create :credit_card, :visa, franchise: fran, exp_year: (Date.today-1.year).strftime("%y").to_i}
  let!(:mc)   {create :credit_card, :mastercard,  franchise: fran, exp_year:(Date.today+1.month).strftime("%y").to_i, exp_month:(Date.today+1.month).strftime("%m")}
    

  describe "Test Model validations" do 
	  #Testing validity of the factory
	  it "has a valid factory" do 
	    expect(build(:credit_card)).to be_valid
    end

	  it "is invalid without franchide_id" do  
	    expect(build(:credit_card, franchise: nil)).not_to be_valid
	  end 

  	it "is invalid without card number" do  
  	  expect(build(:credit_card, cc_number: nil)).not_to be_valid	
    end

    it "is invalid without card type" do
      expect(build(:credit_card, cc_type: nil)).not_to be_valid  
    end

    it "is invalid without expiration month" do  
      expect(build(:credit_card, cc_exp_month: nil )).not_to be_valid  
    end

    it "is invalid without expiration year" do  
      expect(build(:credit_card, cc_exp_year: nil )).not_to be_valid  
    end

    it "is invalid without address" do  
      expect(build(:credit_card, cc_address: nil)).not_to be_valid  
    end

    it "is invalid without city" do  
      expect(build(:credit_card, cc_city: nil)).not_to be_valid  
    end

    it "is invalid without city" do  
      expect(build(:credit_card, cc_state: nil)).not_to be_valid  
    end

    it "is invalid without zip" do  
      expect(build(:credit_card, cc_zip: nil)).not_to be_valid  
    end


  end

  describe "Test the instance methods" do
    describe "#card_type_and_number" do 
      it "should return the proper value" do 
        expect(visa.card_type_and_number).to eq("#{visa.card_type_desc} #{I18n.t('credit_card.ending_in')} #{visa.last_four}")
      end
    end

    describe "#franchise_name_card_lastfour" do 
      it "should return the proper value" do 
        expect(visa.franchise_name_card_lastfour).to eq([visa.franchise&.number_and_name, visa.card_type_desc, visa.last_four].join("-"))
      end
    end

    describe "#card_type_desc" do
      it "should return the proper value" do 
        expect(visa.card_type_desc).to eq("Visa")
        expect(mc.card_type_desc).to eq("MasterCard")
      end
    end

    describe "#expiring_data" do 
      it "should return the proper value" do 
        expect(visa.expiring_data).to eq("#{visa.exp_month} / #{visa.exp_year}")
      end
    end

    describe "expired?" do 
      it "should return the proper value" do 
        expect(visa.expired?).to eq(true)
        expect(mc.expired?).to eq(false)
      end
    end

    describe "expiring?" do 
      it "should return the proper value" do 
        expect(visa.expiring?).to eq(false)
        expect(mc.expiring?).to eq(true)
      end
    end
  end
end