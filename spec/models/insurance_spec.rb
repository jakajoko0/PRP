require 'rails_helper'

RSpec.describe Insurance, type: :model do 
  let!(:glass)    {create :franchise, lastname: "Glass", firstname: "Forrest"}
  let!(:kittle)   {create :franchise, lastname: "Kittle", firstname: "Theresa"}
  let!(:glass_insurance) {create :insurance,  franchise: glass }
  

  describe "Test Model validations" do 
	  #Testing validity of the factory
	  it "has a valid factory" do 
	    expect(build(:insurance, franchise: kittle)).to be_valid
    end

	  it "is invalid without franchide_id" do  
	    expect(build(:insurance, franchise_id: nil )).not_to be_valid
	  end 

  	it "is invalid when EO checked without expiration date" do  
  	  expect(build(:insurance, eo_insurance: 1, eo_expiration: nil )).not_to be_valid	
    end

    it "is invalid when Gen checked without expiration date" do  
      expect(build(:insurance, gen_insurance: 1, gen_expiration: nil )).not_to be_valid  
    end

    it "is invalid when Other checked without expiration date" do  
      expect(build(:insurance, other_insurance: 1, other_expiration: nil )).not_to be_valid  
    end

    it "is invalid when Other checked without description" do  
      expect(build(:insurance, other_insurance: 1, other_expiration: Date.today+1.year, other_description: nil )).not_to be_valid  
    end

    it "does not accept duplicate insurance for same franchise" do 
      expect(build(:insurance, franchise: glass)).not_to be_valid
    end 

  end

  describe "Test the instance methods" do
    describe "#eo_entered?" do 
      it "should return the proper value" do 
        expect(glass_insurance.eo_entered?).to eq(false)
      end
    end

    describe "#gen_entered?" do 
      it "should return the proper value" do 
        expect(glass_insurance.gen_entered?).to eq(false)
      end
    end

    describe "#other_entered?" do
      it "should return the proper value" do 
        expect(glass_insurance.other_entered?).to eq(false)
      end
    end
  end

  

end