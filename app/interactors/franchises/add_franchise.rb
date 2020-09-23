class AddFranchise
	include Interactor

  def call
	  franchise = Franchise.new(context.params)
	  franchise.set_dates(context.params[:start_date],
		                    context.params[:renew_date],
		                    context.params[:term_date])
	    if franchise.save
    	  context.franchise = franchise
    	  event_info = {fran: franchise.franchise_number,
    	                lastname: franchise.lastname,
    	                description: "Franchise #{franchise.franchise_number} #{franchise.lastname} was Created",
    	                user_email: context.user.email}
        context.log_event = true 
    	  context.event_info = event_info

        insurance = AddInsurance.call(params: {franchise_id: franchise.id, eo_insurance: 0, gen_insurance: 0, other_insurance: 0, other2_insurance: 0}, user: context.user)

	    else
	    	context.franchise = franchise
  	  	context.fail!
	    end
  end
end