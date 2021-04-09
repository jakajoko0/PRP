require 'rails_helper'
RSpec.describe FranchiseDocument, type: :model do 
	

	describe "Testing model validation" do 
		it "has a valid factory" do 
			expect(build(:franchise_document)).to be_valid
		end

		
		it "is invalid without a description" do 
			expect(build(:franchise_document, description: nil)).not_to be_valid
		end

		it "is invalid without a document type" do 
			expect(build(:franchise_document, document_type: nil)).not_to be_valid
		end

		it "is invalid without a document attachment" do 
			expect(build(:franchise_document, document: nil)).not_to be_valid
		end

		it "is invalid without proper document type" do 
			expect(build(:franchise_document, :with_invalid_document)).not_to be_valid
		end

	end

	
end