class AddReceivables
  include Interactor
  #**************************************************
  # This Interactor is called from the create_remittance
  # or update_remittance interactor and gets 
  # information from them as to what needs to happen
  #**************************************************
  def call
  	#**************************************************
    # Only write receivables if the remittance is posted
    #**************************************************
  	if context.remittance.posted?
      #First we delete any receivables
      #Tied to this Remittance (easier than to change amount)
      context.remittance.prp_transactions.where(trans_type: :receivable).destroy_all

      ActiveRecord::Base.transaction do 
  		  #Get the saved remittance
  		  remittance = context.remittance
  		  #*********************************************
  		  # Create the Receivable for Royalty
  		  #*********************************************
  		  desc = "Royalty for #{Date::MONTHNAMES[remittance.month]} #{remittance.year}"
  		  PrpTransaction.create!(franchise_id: remittance.franchise_id,
  													 date_posted: remittance.date_posted,
  													 trans_type: :receivable,
  													 trans_code: "01",
  													 trans_description: desc,
  													 amount: remittance.royalty,
  													 transactionable: remittance)
  		  #*********************************************
  		  # Create Receivable for Late Fees if any
  		  #*********************************************
  		  if remittance.late_fees > 0.00
  			  desc = "Late Fee for #{Date::MONTHNAMES[remittance.month]} #{remittance.year}"
  			  PrpTransaction.create!(franchise_id: remittance.franchise_id,
  													 date_posted: remittance.date_posted,
  													 trans_type: :receivable,
  													 trans_code: "34",
  													 trans_description: desc,
  													 amount: remittance.late_fees,
  													 transactionable: remittance)
  		  end
 	    end
    end
 	rescue ActiveRecord::RecordInvalid => exception
    context.remittance.errors.add(:base, "An error occured saving credits: #{exception.message}")
 		context.fail!
  end

  def rollback
  	context.remittance.prp_transactions.where(trans_type: :receivable).destroy_all
  end
end