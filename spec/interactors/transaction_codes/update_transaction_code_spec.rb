require "rails_helper"

RSpec.describe "Interactor - UpdateTransactionCode", :type => :interactor do 
	let!(:admin) {create(:admin)}
	let!(:trans_code)    {create :transaction_code}
	let(:changed_attributes) {trans_code.attributes.symbolize_keys.merge(description: "New Description")}

	describe ".call" do 
		context "When given valid attributes" do 
			it "should update transaction code" do 
				interactor = UpdateTransactionCode.call(trans_code: trans_code,params: changed_attributes, user: admin)
				expect(interactor).to be_a_success
				expect(trans_code.reload.description).to eq changed_attributes[:description]
			end

		end

		context "When given invalid attributes" do 
			it "should not update transaction code" do 
				interactor = UpdateTransactionCode.call(trans_code: trans_code, params: changed_attributes.merge(description: nil), user: admin)
				expect(interactor).to be_a_failure
				expect(trans_code.reload.description).to_not eq nil
			end

		end
	end

end