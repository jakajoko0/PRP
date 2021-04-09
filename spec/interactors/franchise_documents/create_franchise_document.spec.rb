require "rails_helper"

RSpec.describe "Interactor - CreateFranchiseDocument", type: :interactor do 
	let!(:user) {create(:user)}
	let!(:fran) {create(:franchise)}
	let!(:params) {FactoryBot.attributes_for(:franchise_document)}

	describe ".call" do 
		context "When given valid attributes" do
		subject {CreateFranchiseDocument.call(params: params.merge(franchise_id:fran.id))} 
			it "should create franchise document" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(interactor.franchise_document).to eq(FranchiseDocument.last)
			end

		end

		context "When given invalid attributes" do 
			subject {CreateFranchiseDocument.call(params: params.merge(description: nil))}
			it "should not create franchise document" do 
				interactor = subject
				expect(interactor).to be_a_failure
			end
		end
	end

end