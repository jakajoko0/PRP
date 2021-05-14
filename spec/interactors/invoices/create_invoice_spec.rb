require "rails_helper"

RSpec.describe "Interactor - CreateInvoice", type: :interactor do 
	let!(:user) {create(:user)}
	let!(:fran) {create(:franchise)}
	let!(:params) {FactoryBot.attributes_for(:invoice, date_entered: Date.new(Date.today.year,1,1).strftime("%m/%d/%Y"))}

	describe ".call" do 
		context "When given valid attributes" do
		subject {CreateInvoice.call(params: params.merge(franchise_id:fran.id) , user: user)} 
			it "should create invoice" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(interactor.invoice).to eq(Invoice.last)
			end

			it "should log an event" do 
				expect{subject}.to change{EventLog.count}.by(1)
			end

		end

		context "When given invalid attributes" do 
			subject {CreateInvoice.call(params: params.merge(note: nil), user: user)}
			it "should not create an invoice" do 
				interactor = subject
				expect(interactor).to be_a_failure
			end

			it "should not log an event" do 
				expect{subject}.to_not change{EventLog.count}
			end

		end
	end

end