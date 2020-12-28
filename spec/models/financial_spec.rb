require 'rails_helper'

RSpec.describe Financial, type: :model do 
  let!(:frans)    {create_list :franchise, 5}
  let!(:financial1) {create :financial, franchise: frans[0]}
  let!(:financial2) {create :financial, franchise: frans[0], year: Date.today.year-1}
  let!(:financial3) {create :financial, franchise: frans[0], year: Date.today.year+1}
  let!(:financial4) {create :financial, franchise: frans[1]}
  

  describe "Test Model validations" do 
	  #Testing validity of the factory
	  it "has a valid factory" do 
	    expect(build(:financial)).to be_valid
    end

    #Test validation of missing values that dont allow null
	  it "is invalid without year" do 
      
  	  expect(build(:financial, year: nil )).not_to be_valid
  	end

	  it "expects description if other amount entered" do 
	    expect(build(:financial, other1_desc: nil, other1: 100 )).not_to be_valid
      expect(build(:financial, other2_desc: nil, other2: 100 )).not_to be_valid
      expect(build(:financial, other3_desc: nil, other3: 100 )).not_to be_valid
	  end
    
    it "is invalid with negative Revenue numbers" do 
      Financial::REVENUE_ATTRIBUTES.each do |attrib| 
        expect(build(:financial, "#{attrib}": -1)).not_to be_valid
      end
    end
	 
	  it "is invalid with negative Expense numbers" do 
      Financial::EXPENSE_ATTRIBUTES.each do |attrib|
        expect(build(:financial, "#{attrib}": -1)).not_to be_valid
      end 
	  end

    it "is invalid with negative Other Expense numbers" do 
      Financial::OTHER_EXPENSES.each do |attrib|
        expect(build(:financial, "#{attrib}": -1)).not_to be_valid
      end 
    end

    it "is invalid with negative Other Revenue numbers" do 
      expect(build(:financial, other_income: -1)).not_to be_valid
      expect(build(:financial, interest_income: -1)).not_to be_valid
    end
	  
    it "does not accept duplicate report for the same franchise and year" do 
      expect(build(:financial, franchise: frans[0])).not_to be_valid
    end

  end

  describe "Test the instance methods" do 
     describe "#other1_entered?" do 
       it "should return the proper result" do 
         expect(financial1.other1_entered?).to eq(true)
       end
     end

     describe "#other2_entered?" do 
       it "should return the proper result" do 
         expect(financial1.other2_entered?).to eq(true)
       end
     end

     describe "#other3_entered?" do 
       it "should return the proper result" do 
         expect(financial1.other3_entered?).to eq(true)
       end
     end

     describe "total_revenues" do 
      it "should return the proper total" do 
        tot = 0
        Financial::REVENUE_ATTRIBUTES.each do |attrib|
          tot = tot + financial1.send(attrib)
        end
        expect(financial1.total_revenues).to eq(tot)
      end

      describe "total_expenses" do 
        it "should return the proper total" do
          tot = 0 
          Financial::EXPENSE_ATTRIBUTES.each do |attrib|
            tot = tot + financial1.send(attrib)
          end
          expect(financial1.total_expenses).to eq(tot)
        end
      end
    end
  end

  describe "Test the Class Methods" do 
    describe ".get_min_year" do 
      it "should return the proper year" do 
        expect(Financial.get_min_year).to eq(Date.today.year-1)
      end
    end

    describe ".get_max_year" do 
      it "should return the proper year" do 
        expect(Financial.get_max_year).to eq(Date.today.year+1)
      end
    end

    describe ".get_history" do 
      it "should return the proper years" do
        result = Financial.get_history(frans[0].id)
        years = result.map{|i| i.year}
        expect(years).to eq([Date.today.year+1, Date.today.year, Date.today.year-1])
      end
    end
  end
  

end