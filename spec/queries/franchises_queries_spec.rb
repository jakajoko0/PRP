require "rails_helper"

RSpec.describe "FranchisesQuery", :type => :query do 

	describe "#franchise_list_sorted" do 
		subject(:sorted_by_franchise) {FranchisesQuery.new.franchise_list_sorted(0,'franchise_number')}
		subject(:sorted_by_lastname) {FranchisesQuery.new.franchise_list_sorted(0,'lastname')}
		subject(:including_inactives) {FranchisesQuery.new.franchise_list_sorted(1,'franchise_number')}

		
			let!(:kittle) {create :franchise, lastname: "Kittle", firstname: "Teresa"}
		  let!(:glass) {create :franchise, lastname: "Glass", firstname: "Forrest"}
		  let!(:inactive) {create :franchise, lastname: "Franchise", firstname: "Inactive", inactive: 1}
	  

	  it "returns the proper list sorted by franchise" do 
	  	expect(sorted_by_franchise.size).to eq(2)
	  	expect(sorted_by_franchise).to eq([kittle,glass])
	  end

	  it "returns the proper list sorted by lastname" do 
	  	expect(sorted_by_lastname.size).to eq(2)
	  	expect(sorted_by_lastname).to eq([glass,kittle])
	  end

	  it "returns the proper list when inactives included" do 
	  	expect(including_inactives.size).to eq(3)
	  	expect(including_inactives).to eq([kittle,glass,inactive])
	  end
	end

end
