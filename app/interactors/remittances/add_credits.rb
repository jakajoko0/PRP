class AddCredits
  include Interactor
  #**************************************************
  # This Interactor is called from the create_remittance
  # or update_remittance interactor and gets 
  # information from them as to what needs to happen
  #**************************************************
  def call
    #**************************************************
    # Only write credits if the remittance is posted
    #**************************************************
  	if context.remittance.posted?
      #First we delete any credits
      #Tied to this Remittance (easier than to change amount)      
       context.remittance.prp_transactions.where(trans_type: :credit).destroy_all
  	  ActiveRecord::Base.transaction do 
  		  #Get the saved remittance
  		  remittance = context.remittance
  		  #*********************************************
  		  # Create the Credits if we have any
  		  #********************************************* 
  		  if remittance.credit1_entered?
 		      desc = "Credit from Royalty on #{Date::MONTHNAMES[remittance.month]} #{remittance.year}"
  		    PrpTransaction.create!(franchise_id: remittance.franchise_id,
  													 date_posted: remittance.date_posted,
  													 trans_type: :credit,
  													 trans_code: remittance.credit1,
  													 trans_description: desc,
  													 amount: remittance.credit1_amount,
  													 transactionable: remittance)
  		  end

  		  if remittance.credit2_entered?
 		      desc = "Credit from Royalty on #{Date::MONTHNAMES[remittance.month]} #{remittance.year}"
  		    PrpTransaction.create!(franchise_id: remittance.franchise_id, 
  													 date_posted: remittance.date_posted,
  													 trans_type: :credit,
  													 trans_code: remittance.credit2,
  													 trans_description: desc,
  													 amount: remittance.credit2_amount,
  													 transactionable: remittance)
  		  end

  		  if remittance.credit3_entered?
 		      desc = "Credit from Royalty on #{Date::MONTHNAMES[remittance.month]} #{remittance.year}"
  		    PrpTransaction.create!(franchise_id: remittance.franchise_id,
  													 date_posted: remittance.date_posted,
  													 trans_type: :credit,
  													 trans_code: remittance.credit3,
  													 trans_description: desc,
  													 amount: remittance.credit3_amount,
  													 transactionable: remittance)
  		  end

  		  if remittance.credit4_entered?
 		      desc = "#{remittance.credit4} from Royalty on #{Date::MONTHNAMES[remittance.month]} #{remittance.year}"
  		    PrpTransaction.create!(franchise_id: remittance.franchise_id,
  													 date_posted: remittance.date_posted,
  													 trans_type: :credit,
  													 trans_code: "29",
  													 trans_description: desc,
  													 amount: remittance.credit4_amount,
  													 transactionable: remittance)
  		  end
        #If prior rebate amount was used in this remittance
  		  if remittance.prior_year_rebate_used?
          #Check if the remittance was just posted
          if context.just_posted 
  			   amount = remittance.prior_year_rebate_current
          end

          if context.re_posted
            amount = remittance.prior_year_rebate_current - context.old_prior_year_rebate
          end
  			  franchise = Franchise.find(remittance.franchise_id)
  			  current_balance = franchise.prior_year_rebate 

  			  if amount > 0.00
  				  new_balance = current_balance - amount 
  			  else
  				  new_balance = current_balance + amount.abs
  			  end
  			  franchise.prior_year_rebate = new_balance 
  			  if !franchise.save
  				  raise ActiveRecord::RecordInvalid
  			  end
    		end
   	  end
   	end
 	rescue ActiveRecord::RecordInvalid => exception
    context.remittance.errors.add(:base, "An error occured saving credits: #{exception.message}")
		context.fail!
  end

  def rollback
  	context.remittance.prp_transactions.where(trans_type: :credit).destroy_all
  end
end