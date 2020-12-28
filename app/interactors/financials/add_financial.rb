class AddFinancial
	include Interactor
	
	def call
		financial = Financial.new(context.params)

		if financial.save 
			context.financial = financial
			event_info = {fran: financial.franchise.franchise_number,
									  lastname: financial.franchise.lastname,
									  description: "Created Financial Record for #{financial.year}",
									  user_email: context.user.email}
			context.event_info = event_info
			context.log_event = true
	  else
	  	context.financial = financial 
	  	context.fail!
	  end
	end

end