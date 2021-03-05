require 'rails_helper'

RSpec.describe Remittance, type: :model do 
  let!(:frans)    {create_list :franchise, 5}
  let!(:remittance1) {create :remittance, franchise: frans[0], credit1: "01", credit1_amount: 100, credit2: "02", credit2_amount: 200, credit3: "03", credit3_amount: 300, credit4: "Other Credit", credit4_amount: 400, payroll_credit_desc: "Description", payroll_credit_amount: 500 }
  let!(:remittance2) {create :remittance, :posted, franchise: frans[1], year: Date.today.year + 1}
  let!(:remittance3) {create :remittance, :posted, franchise: frans[1], year: Date.today.year }
  let!(:remittance4) {create :remittance, :posted, franchise: frans[2], late: 1, late_reason: "Out of town", credit1: "35", credit1_amount: 200}
 

  describe "Test Model validations" do 
	  #Testing validity of the factory
	  it "has a valid factory" do 
	    expect(build(:remittance)).to be_valid
    end

    #Test validation of missing values that dont allow null
	  it "is invalid without year" do 
  	  expect(build(:remittance, year: nil )).not_to be_valid
  	end

    #Test validation of missing values that dont allow null
    it "is invalid without month" do 
      expect(build(:remittance, month: nil )).not_to be_valid
    end

    it "is invalid without a status" do 
      expect(build(:remittance, status: nil)).not_to be_valid
    end

    it "is invalid without a date received" do 
      expect(build(:remittance, date_received: nil)).not_to be_valid
    end

    it "is invalid without a date posted if posted" do 
      expect(build(:remittance, :posted, date_posted: nil)).not_to be_valid
    end

    it "is invalid without a franchise" do 
      expect(build(:remittance, franchise_id: nil)).not_to be_valid
    end

    it "Doest not allow a remittance for the same year and month " do 
      expect(build(:remittance, franchise: frans[0])).not_to be_valid
    end

	  it "expects description if credit amount entered" do 
	    expect(build(:remittance, credit1: nil, credit1_amount: 100 )).not_to be_valid
      expect(build(:remittance, credit2: nil, credit2_amount: 100 )).not_to be_valid
      expect(build(:remittance, credit3: nil, credit3_amount: 100 )).not_to be_valid
      expect(build(:remittance, credit4: nil, credit4_amount: 100 )).not_to be_valid
	  end
	 
	  it "is invalid with negative royalty" do 
      expect(build(:remittance, royalty: -1)).not_to be_valid
	  end

    it "is invalid if the same credit is used more than once" do 
      expect(build(:remittance, credit1: '01', credit2: '01', credit3: '02', credit4: 'test'))
      expect(build(:remittance, credit1: '01', credit2: '02', credit3: '01', credit4: 'test'))
      expect(build(:remittance, credit1: '01', credit2: '02', credit3: '02', credit4: 'test'))
    end

    it "is invalid without a reason if late" do 
      expect(build(:remittance, late: 1, late_reason: nil )).not_to be_valid
    end
    

  end

  describe "Test the instance methods" do 
    describe "#credit1_entered?" do 
      it "should return the proper result" do 
        expect(remittance1.credit1_entered?).to eq(true)
      end
    end

    describe "#credit2_entered?" do 
      it "should return the proper result" do 
        expect(remittance1.credit2_entered?).to eq(true)
      end
    end

    describe "#credit3_entered?" do 
      it "should return the proper result" do 
        expect(remittance1.credit3_entered?).to eq(true)
      end
    end

    describe "#late_royalty?" do 
      it "should return the proper result" do 
        expect(remittance1.late_royalty?).to eq(false)
        expect(remittance4.late_royalty?).to eq(true)
      end
    end

    describe "#prior_rebate_used?" do 
      it "should return the proper value" do 
        expect(remittance1.prior_year_rebate_used?).to eq(false)
        expect(remittance4.prior_year_rebate_used?).to eq(true)
      end
    end

    describe "#is_posted?" do
      it "should return the proper value" do 
        expect(remittance1.is_posted?).to eq(false)
        expect(remittance4.is_posted?).to eq(true)
      end
    end

    describe "#total_collections" do 
      it "should return the proper total" do 
        tot = 0
        Remittance::COLLECTIONS_ATTRIBUTES.each do |attrib|
          tot = tot + remittance1.send(attrib)
        end
        expect(remittance1.total_collections).to eq(tot)
      end
    end  
    
    describe "#calc_royalties" do 
      it "should return the proper total" do
        tot = 0
        Remittance::ATTRIBUTES_FOR_ROYALTY.each do |attrib|
          tot = tot + remittance1.send(attrib)
        end
        expect(remittance1.calc_royalties).to eq(tot*Remittance::ROYALTY_RATE)
      end
    end

    describe "#total_credits" do 
      it "should return the proper total" do
        tot = 0
        Remittance::CREDIT_ATTRIBUTES.each do |attrib|
          tot = tot + remittance1.send(attrib)
        end
        expect(remittance1.total_credits).to eq(tot)
      end
    end
  end

  describe "Test the Class Methods" do 
    describe ".get_min_year" do 
      it "should return the proper year" do 
        expect(Remittance.get_min_year).to eq(Date.today.year)
      end
    end

    describe ".get_max_year" do 
      it "should return the proper year" do 
        expect(Remittance.get_max_year).to eq(Date.today.year+1)
      end
    end

    describe ".get_history" do 
      it "should return the proper years and months" do
        result = Remittance.get_history(frans[1].id)
        years = result.map{|i| i.year}
        months = result.map{|i| i.month}
        expect(years).to eq([Date.today.year+1, Date.today.year])
        expect(months).to eq([Date.today.month, Date.today.month])

      end
    end
  end
  

end