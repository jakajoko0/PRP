class AddAccountant
  include Interactor
  
  def call
  	accountant = Accountant.new(context.params)
  	accountant.set_dates(context.params[:start_date],
                        context.params[:birthdate],
		                    context.params[:spouse_birthdate],
                        context.params[:term_date])
  	if accountant.save
      context.accountant = accountant 
      event_info = {fran: accountant.franchise.franchise_number,
      	            lastname: accountant.franchise.lastname,
      	            description: "Accountant #{accountant.accountant_num} #{accountant.lastname} was created",
      	            user_email: context.user.email}
      context.event_info = event_info
      context.log_event = true
    else
    	context.accountant = accountant 
    	context.fail!
    end
  end
end