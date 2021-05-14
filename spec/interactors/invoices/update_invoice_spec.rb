require "rails_helper"

RSpec.describe "Interactor - UpdateInvoice", type: :interactor do 
	let!(:user) {create(:user)}
	let!(:fran)    {create :franchise}
	let!(:invoice) {create :invoice, franchise: fran}
	let(:changed_attributes) {invoice.attributes.symbolize_keys.merge(note: "My New Note",date_entered: invoice.date_entered.strftime("%m/%d/%Y"))}

	describe ".call" do 
		context "When given valid attributes" do 
			subject {UpdateInvoice.call(invoice: invoice,params: changed_attributes, user: user)}
			it "should update invoice" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(invoice.reload.note).to eq changed_attributes[:note]
			end

		end

		context "When given invalid attributes" do 
			subject {UpdateInvoice.call(invoice: invoice ,params: changed_attributes.merge(note: nil), user: user)}
			it "should not update invoice" do 
				interactor = subject
				expect(interactor).to be_a_failure
				expect(invoice.reload.note).to_not eq changed_attributes[:note]
			end

		end
	end

end