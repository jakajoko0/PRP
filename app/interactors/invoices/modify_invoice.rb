class ModifyInvoice
  include Interactor

  def call
    #*********************************************
  	# Update the Remittance with Form params 
  	#****************************************************
    #Get the current remittance (the one in the database)
    #****************************************************
  	invoice = context.invoice

    #Assign new params
    invoice.assign_attributes(context.params)
    invoice.set_dates(context.params[:date_entered])
    invoice.admin_generated = context.admin == true ? 1 : 0

 			
    #*********************************************
	  # Try the save the Remittance
 	  #*********************************************
  	if invoice.save 
  		context.invoice = invoice
  	else
  	  context.invoice = invoice
  	  context.fail!
  	end	
  end
  #*************************************************
  #Rollback the saved remittance
  #Switch the form remittance object back to pending
  #*************************************************
  def rollback
    context.invoice.destroy
  end
end