require "rails_helper"

RSpec.describe "Interactor - CreateRemittance", :type => :interactor do 
	let!(:user) {create(:user)}
	let!(:fran) {create(:franchise, prior_year_rebate: 1000 )}
	let!(:params) {FactoryBot.attributes_for(:remittance)}
	let!(:posted_params){FactoryBot.attributes_for(:remittance).merge(confirmation: 1)}
	let!(:one_credit_params){FactoryBot.attributes_for(:remittance).merge(confirmation: 1, credit1: '01', credit1_amount: 100)}
	let!(:two_credit_params){FactoryBot.attributes_for(:remittance).merge(confirmation: 1, credit1: '01', credit1_amount: 100, credit2: '02', credit2_amount: 200)}
	let!(:three_credit_params){FactoryBot.attributes_for(:remittance).merge(confirmation: 1, credit1: '01', credit1_amount: 100, credit2: '02', credit2_amount: 200, credit3: '03', credit3_amount: 300)}

	describe ".call" do 
		context "When given valid attributes and not posted" do 
			subject {CreateRemittance.call(params: params.merge(franchise_id:fran.id),
					                                 admin: false,
					                                 submit_type: "Save for Later")}
			it "should create remittance" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(interactor.remittance).to eq(Remittance.last)
			end

			it "should not create a receivable" do 
				expect{subject}.to_not change{PrpTransaction.receivable.count}
			end

			it "should not create credit" do 
        expect{subject}.to_not change{PrpTransaction.receivable.count}
		  end
	  end

		context "When given valid attributes and posted" do 
			subject {CreateRemittance.call(params: posted_params.merge(franchise_id:fran.id ),
					                                 admin: false,
					                                 submit_type: "Save and Post")} 
			it "should create remittance" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(interactor.remittance).to eq(Remittance.last)
			end

			it "should add a receivable" do 
				expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
			end

			it "should not create credit" do 
        expect{subject}.to_not change{PrpTransaction.credit.count}
		  end
		end

		context "When given valid attributes, one credit and posted" do 
			subject {CreateRemittance.call(params: one_credit_params.merge(franchise_id:fran.id),
					                                 admin: false,
					                                 submit_type: "Save and Post")}
			it "should create remittance" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(interactor.remittance).to eq(Remittance.last)
			end

			it "should add a receivable" do 
				expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
			end

			it "should add a credit" do 
				expect{subject}.to change{PrpTransaction.credit.count}.by(1)
			end
		end

		

		context "When given valid attributes, two credits and posted" do 
			subject {CreateRemittance.call(params: two_credit_params.merge(franchise_id:fran.id),
					                                 admin: false,
					                                 submit_type: "Save and Post")}
			it "should create remittance" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(interactor.remittance).to eq(Remittance.last)
			end

			it "should add a receivable" do 
				expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
			end

			it "should add two credits" do 
				expect{subject}.to change{PrpTransaction.credit.count}.by(2)
			end
		end

		context "When given valid attributes, three credits and posted" do 
			subject {CreateRemittance.call(params: three_credit_params.merge(franchise_id:fran.id),
					                                 admin: false,
					                                 submit_type: "Save and Post")}
			it "should create remittance" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(interactor.remittance).to eq(Remittance.last)
			end

			it "should add a receivable" do 
				expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
			end

			it "should add three credits" do 
				expect{subject}.to change{PrpTransaction.credit.count}.by(3)
			end
		end

		context "When given valid attributes, prior year rebate and posted" do 
			subject {CreateRemittance.call(params: one_credit_params.merge(franchise_id:fran.id, credit1: '35', credit1_amount: 200),
					                                 admin: false,
					                                 submit_type: "Save and Post")}
			it "should create remittance" do 
				interactor = subject
				expect(interactor).to be_a_success
				expect(interactor.remittance).to eq(Remittance.last)
			end

			it "should add a receivable" do 
				expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
			end

			it "should add a credit" do 
				expect{subject}.to change{PrpTransaction.credit.count}.by(1)
			end

			it "should update Franchise Prior Year Rebate" do 
				interactor = subject
				expect(fran.reload.prior_year_rebate).to eq(800.00)
 		  end
		end

		context "When given valid attributes, too much prior year rebate and posted" do 
			subject {CreateRemittance.call(params: one_credit_params.merge(franchise_id:fran.id, credit1: '35', credit1_amount: 1200),
					                                 admin: false,
					                                 submit_type: "Save and Post")}
			it "should not create remittance" do 
				interactor = subject
				expect(interactor).to be_a_failure
  		end

			it "should add a receivable" do 
				expect{subject}.not_to change{PrpTransaction.receivable.count}
			end

			it "should add a credit" do 
				expect{subject}.not_to change{PrpTransaction.credit.count}
			end

			it "should not update Franchise Prior Year Rebate" do 
				interactor = subject
				expect(fran.reload.prior_year_rebate).to eq(1000.00)
 		  end
		end

		context "When given invalid attributes" do 
			subject {CreateRemittance.call(params: params.merge(franchise_id: fran.id, year: nil),
					                                 admin: false,
					                                 submit_type: "Save for Later")}
			it "should not create remittance" do 
				interactor = subject
				expect(interactor).to be_a_failure
			end

			it "should not create a receivable" do
				expect{subject}.to_not change{PrpTransaction.receivable.count}
			end

			it "should not create a credit" do 
				expect{subject}.to_not change{PrpTransaction.credit.count}
			end

		end

	  context "When given invalid attributes posted" do
	  subject {CreateRemittance.call(params: posted_params.merge(franchise_id: fran.id, year: nil),
					                                 admin: false,
					                                 submit_type: "Save for Later")} 
			it "should not create remittance" do 
				interactor = subject 
				expect(interactor).to be_a_failure
			end

			it "should not create a receivable" do
				expect{subject}.to_not change{PrpTransaction.receivable.count}
			end

			it "should not create a credit" do 
				expect{subject}.to_not change{PrpTransaction.credit.count}
			end
		end
	end

end