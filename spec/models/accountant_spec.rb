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
        expect(glass_accountant.full_denomination).to eq([glass_accountant.accountant_num,glass_accountant.firstname, glass_accountant.lastname].join(" "))
      end
    end

    describe "#franchise_and_name" do
      it "should return the proper format for franchise and name" do 
        expect(glass_accountant.franchise_and_name).to eq([glass.number_and_name, glass_accountant.accountant_num, glass_accountant.firstname, glass_accountant.lastname].join("-"))
      end
    end

    describe "#number_and_name" do
      it "should return the proper number and name" do 
        expect(glass_accountant.number_and_name).to eq([glass_accountant.accountant_num, glass_accountant.lastname].join(" "))
      end
    end

    describe "#name_or_number_has_changed?" do
      it "should return false when the name or number does not change" do 
        expect(glass_accountant.name_or_number_has_changed?).to eq(false)
      end
      it "should return true when the name changes" do 
        glass_accountant.firstname = "Maurice"
        expect(glass_accountant.name_or_number_has_changed?).to eq(true)
      end
      it "should return true when the number changes" do 
        glass_accountant.accountant_num = '03'
        expect(glass_accountant.name_or_number_has_changed?).to eq(true)
      end

    end

    describe "#set_dates" do 
      it "should format the date properly" do 
        start = Date.new(2020,1,1)
        birth = Date.new(2020,2,1)
        spouse = Date.new(2020,3,1)
        term = Date.new(2020,4,1)
        glass_accountant.set_dates("01/01/2020","02/01/2020","03/01/2020","04/01/2020")
        expect(glass_accountant.start_date).to eq(start)
        expect(glass_accountant.birthdate).to eq(birth)
        expect(glass_accountant.spouse_birthdate).to eq(spouse)
        expect(glass_accountant.term_date).to eq(term)
      end
    end
  end

  describe "Testing class methods" do 
    describe ".search" do 
      it "should filter the list properly" do 
        filtered = Accountant.search("Gl")
        expect(filtered).to contain_exactly(glass_accountant)
      end
    end
  end

end