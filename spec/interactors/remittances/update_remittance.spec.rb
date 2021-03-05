require "rails_helper"

RSpec.describe "Interactor - UpdateRemittance", :type => :interactor do 
	let!(:user) {create(:user)}
	let!(:fran)    {create :franchise, prior_year_rebate: 1000}
	#One pending remittance
	let!(:pending_remittance) {create :remittance, franchise: fran, month: 3, year: Date.today.year}
	#One posted remittance
	let!(:posted_remittance) {create :remittance, :posted, franchise: fran, month: 2, year: Date.today.year}
	#One posted remittance with prior rebate credit
	let!(:posted_with_prior) {create :remittance, :posted, franchise: fran, month: 1, year: Date.today.year, credit1: '35', credit1_amount: 200}
	#Changed attributes for both posted and pending
	let(:changed_attributes) {pending_remittance.attributes.symbolize_keys.merge(accounting: 99999)}
	let(:changed_posted_attributes) {posted_remittance.attributes.symbolize_keys.merge(accounting: 99999, date_received: Date.new(Date.today.year,2,1).strftime("%m/%d/%Y"), date_posted: Date.new(Date.today.year,2,1).strftime("%m/%d/%Y"))}
	let(:changed_posted_with_prior_attributes) {posted_with_prior.attributes.symbolize_keys.merge(accounting: 99999, date_received: Date.new(Date.today.year,2,1).strftime("%m/%d/%Y"), date_posted: Date.new(Date.today.year,2,1).strftime("%m/%d/%Y"))}

	describe ".call" do 
		describe "Pending Remittance" do 
		  context "When given valid attributes" do 
		  	subject {UpdateRemittance.call(remittance: pending_remittance,
					                                 params: changed_attributes,
					                                 user: user,
					                                 admin: false,
					                                 submit_type: "Save for Later")}
			  it "should update remittance" do 
				  interactor = subject
				  expect(interactor).to be_a_success
				  expect(pending_remittance.reload.accounting).to eq changed_attributes[:accounting]
			  end

			  it "should not add receivable" do 
				  expect{subject}.not_to change{PrpTransaction.receivable.count}
			  end


			  it "should not add credit" do 
				  expect{subject}.not_to change{PrpTransaction.credit.count}
			  end

		  end

		  context "When given valid attributes and posted" do
		    subject {UpdateRemittance.call(remittance: pending_remittance,
		  		params: changed_attributes.merge(confirmation: 1),
		  		user: user,
		  		admin: false,
		  		submit_type: "Save and Post")} 
		  	it "should update remittance" do 
		  	  interactor = subject
		  	  expect(interactor).to be_a_success
		  	  expect(pending_remittance.reload.accounting).to eq changed_attributes[:accounting]
		  	end

		  	it "should create a receivable" do 
		  		expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
		  	end

		  	it "should not create a credit" do 
		  		expect{subject}.not_to change{PrpTransaction.credit.count}
		  	end

		  end

		  context "When given valid attributes, 1 credit, posted" do
		  	subject {UpdateRemittance.call(remittance: pending_remittance,
		  		params: changed_attributes.merge(confirmation: 1, credit1: "01", credit1_amount: 100),
		  		user: user,
		  		admin: false,
		  		submit_type: "Save and Post")}
		  	
		  	it "should update the remittance" do 
		  		interactor = subject
		  	  expect(interactor).to be_a_success
		  	  expect(pending_remittance.reload.accounting).to eq changed_attributes[:accounting]
		  	end

		  	it "should create a receivable" do 
		  		expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
		  	end

		  	it "should create one credit" do 
		  		expect{subject}.to change{PrpTransaction.credit.count}.by(1)

		  	end
		  end

		  context "When given valid attributes, 2 credit, posted" do
		  	subject {UpdateRemittance.call(remittance: pending_remittance,
		  		params: changed_attributes.merge(confirmation: 1, credit1: "01", credit1_amount: 100, credit2: "02", credit2_amount: 200),
		  		user: user,
		  		admin: false,
		  		submit_type: "Save and Post")}
		  	
		  	it "should update the remittance" do 
		  		interactor = subject
		  	  expect(interactor).to be_a_success
		  	  expect(pending_remittance.reload.accounting).to eq changed_attributes[:accounting]
		  	end

		  	it "should create a receivable" do 
		  		expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
		  	end

		  	it "should create two credits" do 
		  		expect{subject}.to change{PrpTransaction.credit.count}.by(2)
 	  	  end
		  end

		  context "When given valid attributes, 3 credit, posted" do
		  	subject {UpdateRemittance.call(remittance: pending_remittance,
		  		params: changed_attributes.merge(confirmation: 1, credit1: "01", credit1_amount: 100, credit2: "02", credit2_amount: 200, credit3: "03", credit3_amount: 300),
		  		user: user,
		  		admin: false,
		  		submit_type: "Save and Post")}

		  	it "should update the remittance" do 
		  		interactor = subject
		  	  expect(interactor).to be_a_success
		  	  expect(pending_remittance.reload.accounting).to eq changed_attributes[:accounting]
		  	end

		  	it "should create a receivable" do 
		  		expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
		  	end

		  	it "should create three credits" do 
		  		expect{subject}.to change{PrpTransaction.credit.count}.by(3)
		  	end
		  end

		  context "When given valid attributes, Prior rebate, posted" do 
		  	subject {UpdateRemittance.call(remittance: pending_remittance,
		  		params: changed_attributes.merge(confirmation: 1, credit1: "35", credit1_amount: 100),
		  		user: user,
		  		admin: false,
		  		submit_type: "Save and Post")}

		  	it "should update the remittance" do 
		  		interactor = subject
		  	  expect(interactor).to be_a_success
		  	  expect(pending_remittance.reload.accounting).to eq changed_attributes[:accounting]
		  	end

		  	it "should create a receivable" do 
		  		expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
		  	end

		  	it "should create one credit" do 
		  		expect{subject}.to change{PrpTransaction.credit.count}.by(1)

		  	end

		  	it "should update Franchise Prior Year Rebate" do 
				  interactor = subject
				  expect(fran.reload.prior_year_rebate).to eq(900.00)
			  end
		  end
    
		  context "When given invalid attributes" do 
		  	subject {UpdateRemittance.call(remittance: pending_remittance,
				  	params: changed_attributes.merge(year: nil),
				  	user: user,
				  	admin: false,
				  	submit_type: "Save for Later")}

			  it "should not update Remittance" do 
				  interactor = subject
				  expect(interactor).to be_a_failure
				  expect(pending_remittance.reload.accounting).to_not eq changed_attributes[:accounting]
			  end

			  it "should not create receivable" do 
				  expect{subject}.not_to change{PrpTransaction.receivable.count}
			  end

			  it "should not create a credit" do 
				  expect{subject}.not_to change{PrpTransaction.credit.count}			  	
			  end
			end
    end

    describe "Posted Remittance" do 
    	context "When given valid attributes" do 
    		subject {UpdateRemittance.call(remittance: posted_remittance,
					                                 params: changed_posted_attributes,
					                                 user: user,
					                                 admin: true,
					                                 submit_type: "Save and Post")}
			  it "should update remittance" do 
				  interactor = subject
				  expect(interactor).to be_a_success
				  expect(posted_remittance.reload.accounting).to eq changed_posted_attributes[:accounting]
			  end

			  it "should add a receivable" do 
			  	expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
			  end

			  it "should not add a credit" do 
			  	expect{subject}.not_to change{PrpTransaction.credit.count}
			  end

		  end

		  context "When given valid attributes, 1 credit" do 
    		subject {UpdateRemittance.call(remittance: posted_remittance,
					                                 params: changed_posted_attributes.merge(credit1: "01", credit1_amount: 100),
					                                 user: user,
					                                 admin: true,
					                                 submit_type: "Save and Post")}
			  it "should update remittance" do 
				  interactor = subject
				  expect(interactor).to be_a_success
				  expect(posted_remittance.reload.accounting).to eq changed_posted_attributes[:accounting]
			  end

			  it "should add a receivable" do 
			  	expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
			  end

			  it "should  add a credit" do 
			  	expect{subject}.to change{PrpTransaction.credit.count}.by(1)
			  end

		  end

		  context "When given valid attributes, 2 credits" do 
    		subject {UpdateRemittance.call(remittance: posted_remittance,
					                                 params: changed_posted_attributes.merge(credit1: "01", credit1_amount: 100, credit2: "02", credit2_amount: 200),
					                                 user: user,
					                                 admin: true,
					                                 submit_type: "Save and Post")}
			  it "should update remittance" do 
				  interactor = subject
				  expect(interactor).to be_a_success
				  expect(posted_remittance.reload.accounting).to eq changed_posted_attributes[:accounting]
			  end

			  it "should add a receivable" do 
			  	expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
			  end

			  it "should  add a credit" do 
			  	expect{subject}.to change{PrpTransaction.credit.count}.by(2)
			  end

		  end

		  context "When given valid attributes, 3 credits" do 
    		subject {UpdateRemittance.call(remittance: posted_remittance,
					                                 params: changed_posted_attributes.merge(credit1: "01", credit1_amount: 100, credit2: "02", credit2_amount: 200, credit3: "03", credit3_amount: 300),
					                                 user: user,
					                                 admin: true,
					                                 submit_type: "Save and Post")}
			  it "should update remittance" do 
				  interactor = subject
				  expect(interactor).to be_a_success
				  expect(posted_remittance.reload.accounting).to eq changed_posted_attributes[:accounting]
			  end

			  it "should add a receivable" do 
			  	expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
			  end

			  it "should  add a credit" do 
			  	expect{subject}.to change{PrpTransaction.credit.count}.by(3)
			  end

		  end

		  context "When given valid attributes Prior Rebate" do 
    		subject {UpdateRemittance.call(remittance: posted_with_prior,
					                                 params: changed_posted_with_prior_attributes.merge( credit1_amount: 300),
					                                 user: user,
					                                 admin: true,
					                                 submit_type: "Save and Post")}
    		let!(:prior_year_before) {fran.prior_year_rebate}
    		let!(:current_prior) {posted_with_prior.credit1_amount}

			  it "should update remittance" do 
				  interactor = subject
				  pp interactor.remittance.errors
				  expect(interactor).to be_a_success
				  expect(posted_with_prior.reload.accounting).to eq changed_posted_with_prior_attributes[:accounting]
			  end

			  it "should add a receivable" do 
			  	expect{subject}.to change{PrpTransaction.receivable.count}.by(1)
			  end

			  it "should add a credit" do 
			  	expect{subject}.to change{PrpTransaction.credit.count}.by(1)
			  end

			  it "should decrease or increase the rebate amount by the difference" do 
			  	diff = current_prior - subject.remittance.credit1_amount

			  	if diff.to_f > 0
			  		new_amt = prior_year_before + diff
			  	else
			  		new_amt = prior_year_before - diff.abs
			  	end

			  	expect(fran.reload.prior_year_rebate).to eq(new_amt)
			  end

		  end
    end
	end
end