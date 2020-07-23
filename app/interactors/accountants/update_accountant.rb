class UpdateAccountant
	include Interactor

  def call
  	accountant = context.accountant
  	accountant.assign_attributes(context.params)
    accountant.set_dates(context.params[:start_date],
                        context.params[:birthdate],
		                    context.params[:spouse_birthdate],
                        context.params[:term_date])
	  if accountant.save
      context.accountant = accountant
    else
   	  context.accountant = accountant
  	  context.fail!
    end
  end
end