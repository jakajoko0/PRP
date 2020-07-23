class ModifyFranchise
include Interactor

  def call
  	franchise = context.franchise 
  	franchise.assign_attributes(context.params)
    franchise.set_dates(context.params[:start_date],
    	                  context.params[:renew_date],
    	                  context.params[:term_date])
	  if franchise.save
      if franchise.previous_changes.include?("advanced_rebate")
        context.log_event = true 
        event_info = {fran: franchise.franchise_number,
                      lastname: franchise.lastname,
                      description: "Advanced Rebate Changed from #{franchise.previous_changes[:advanced_rebate][0]} % to #{franchise.previous_changes[:advanced_rebate][1]} %",
                      user_email: context.user.email}
        context.event_info = event_info

      end
      context.franchise = franchise
    else
   	  context.franchise = franchise
  	  context.fail!
    end
  end
end