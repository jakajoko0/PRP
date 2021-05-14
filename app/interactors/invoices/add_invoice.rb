class AddInvoice
	include Interactor 

	def call
		#Create the New Invoice With Form Params
		invoice = Invoice.new(context.params)
		invoice.set_dates(context.params[:date_entered])
		invoice.admin_generated = context.admin == true ? 1 : 0

		if invoice.save 
		  context.invoice = invoice 
		  event_info = {fran: invoice.franchise.franchise_number,
      	            lastname: invoice.franchise.lastname,
      	            description: "Other Charge for #{invoice.note} at #{invoice.invoice_total.to_f} created.",
      	            user_email: context.user.email}
      context.event_info = event_info
      context.log_event = true
	  else		
	  	context.invoice = invoice 
	  	context.fail!
	  end
	end

end