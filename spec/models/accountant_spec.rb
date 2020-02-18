require 'rails_helper'

RSpec.describe Accountant, type: :model do 
  let!(:glass)    {create :franchise, lastname: "Glass", firstname: "Forrest"}
  let!(:kittle)   {create :franchise, lastname: "Kittle", firstname: "Theresa"}
  let!(:glass_accountant) {create :accountant, lastname: "Glass", firstname: "Forrest", franchise: glass }
  let!(:kittle_accountant) {create :accountant, lastname: "Kittle", firstname: "Theresa", franchise: kittle }

  describe "Test Model validations" do 
	  #Testing validity of the factory
	  it "has a valid factory" do 
	    expect(build(:accountant)).to be_valid
    end

	  it "is invalid without lastname" do  
	    expect(build(:accountant, lastname: nil )).not_to be_valid
	  end 

  	it "is invalid without firstname" do  
  	  expect(build(:accountant, firstname: nil )).not_to be_valid	
    end

    it "does not accept duplicate accounant number for same franchise" do 
      expect(build(:accountant, franchise: glass, accountant_num: glass_accountant.accountant_num)).not_to be_valid
    end

    it "does accept duplicate accountant number for another franchise" do 
      expect(build(:accountant, franchise: glass, accountant_num: glass_accountant.accountant_num+'0')).to be_valid
    end 

    it "is invalid without a franchise" do
      expect(build(:accountant, franchise: nil)).not_to be_valid
    end
  end

  describe "Test the instance methods" do
    describe "#full_name" do 
      it "should return the proper fullname" do 
        expect(glass_accountant.full_name).to eq([glass_accountant.firstname,glass_accountant.lastname].join(" "))
      end
    end

    describe "#full_denomination" do 
      it "should return the proper denomination" do 
        expect(glass_accountant.full_denomination).to eq([glass_accountant.accountant_num,glass_accountant.firstname, glass_accountant.lastname].join(" ") )
      end
    end

    describe "#number_and_name" do
      it "should return the proper number and name" do 
        expect(glass_accountant.number_and_name).to eq([glass_accountant.accountant_num, glass_accountant.lastname].join(" "))
      end
    end
  end

  describe 'testing the after_create callback' do
    it "should add a notice for accountant creation" do
      new_accountant = build(:accountant, franchise: glass)
      expect{new_accountant.save}.to change{EventLog.count}.by(1)
    end
  end

end