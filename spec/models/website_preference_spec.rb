require 'rails_helper'

RSpec.describe WebsitePreference, type: :model do 
  let!(:fran) {create :franchise}
  let!(:fran2) {create :franchise}
  let!(:fran3) {create :franchise}
  let!(:ach)    {create :website_preference, :ach, franchise: fran, website_preference: 0}
  let!(:card)  {create :website_preference, :cc, franchise: fran2, website_preference: 1}
  let!(:card2)  {create :website_preference, :cc, franchise: fran3, website_preference: 2}
    

  describe "Test Model validations" do 
	  #Testing validity of the factory
	  it "has a valid factory" do 
	    expect(build(:website_preference)).to be_valid
    end

	  it "is invalid without franchide_id" do  
	    expect(build(:website_preference, franchise: nil)).not_to be_valid
	  end 

  	it "is invalid without website preference" do  
  	  expect(build(:website_preference, website_preference: nil)).not_to be_valid	
    end

    it "is invalid without bank_token if ach selected" do
      expect(build(:website_preference, :ach,  bank_token: nil)).not_to be_valid  
    end

    it "is invalid without card_token if card selected" do  
      expect(build(:website_preference, :cc, card_token: nil )).not_to be_valid  
    end

    it "does not accept duplicate website preference for same franchise" do 
      expect(build(:website_preference, franchise: fran)).not_to be_valid
    end

  end

  describe "Test the instance methods" do
    describe "#paid_with" do 
      it "should return the proper value" do 
        expect(ach.paid_with).to eq("Bank Account")
        expect(card.paid_with).to eq("Credit Card")
      end
    end

    describe "#credit_card_selected?" do 
      it "should return the proper value" do 
        expect(ach.credit_card_selected?).to eq(false)
        expect(card.credit_card_selected?).to eq(true)
      end
    end

    describe "#bank_selected?" do 
      it "should return the proper value" do 
        expect(ach.bank_selected?).to eq(true)
        expect(card.bank_selected?).to eq(false)
      end
    end

    describe "#assign_proper_token" do
      it "should return the proper value" do 
        ach.assign_proper_token
        expect(ach.bank_token).to eq(ach.payment_token)
        card.assign_proper_token
        expect(card.card_token).to eq(card.payment_token)
      end
    end

    describe "#preference_description" do 
      it "should return the proper values" do 
        expect(ach.preference_description).to eq("Basic")
        expect(card.preference_description).to eq("Custom")
        expect(card2.preference_description).to eq("Basic & Link")
      end
    end

    describe "#current_fee" do 
      it "should return the proper values" do
        expect(ach.current_fee).to eq(99.00)
        expect(card.current_fee).to eq(329.99)
        expect(card2.current_fee).to eq(149.99)
      end
    end

  end  
end