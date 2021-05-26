require 'rails_helper'

RSpec.describe DepositTracking, type: :model do 
  let!(:frans)    { create_list :franchise, 5 }
  let!(:deposit1) { create :deposit_tracking, franchise: frans[1] }
 

  describe "Test Model validations" do 
	  #Testing validity of the factory
	  it "has a valid factory" do 
	    expect(build(:deposit_tracking)).to be_valid
    end

    #Test validation of missing values that dont allow null
	  it "is invalid without year" do 
  	  expect(build(:deposit_tracking, year: nil )).not_to be_valid
  	end

    #Test validation of missing values that dont allow null
    it "is invalid without month" do 
      expect(build(:deposit_tracking, month: nil )).not_to be_valid
    end

    it "is invalid without a deposit date" do 
      expect(build(:deposit_tracking, deposit_date: nil)).not_to be_valid
    end

    it "is invalid without a franchise" do 
      expect(build(:deposit_tracking, franchise_id: nil)).not_to be_valid
    end

    it "Doest not allow a deposit_tracking for the same date and amount" do 
      expect(build(:deposit_tracking, franchise: frans[1])).not_to be_valid
    end

    it "Does not save if total deposit does not match all deposits " do 
      expect(build(:deposit_tracking, other1: 9999)).not_to be_valid
    end

    it "Does not allow negative amounts" do 
      expect(build(:deposit_tracking, other1: -1)).not_to be_valid
    end
  end

  describe "Test the instance methods" do 

  end

  describe "Test the Class Methods" do 
  end
  

end