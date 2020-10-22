class UpdateBankAccount
	include Interactor

	def call
		bank_account = context.account
		params = context.params
		bank_account.assign_attributes(params)
		if bank_account.valid? && bank_account.errors.empty?
		gulf = GulfApi::Client.new(Rails.application.credentials.dig(:GULF_API_ID),Rails.application.credentials.dig(:GULF_API_KEY),Rails.application.credentials.dig(:GULF_GMS_ID))
		begin 
      response = gulf.create_bank_token(bank_account.bank_token,
				  	                     params[:type_of_account],
				  	                     params[:routing],
				  	                     params[:name_on_account],
				  	                     params[:account_number])
			  data = response.to_array(:token_input_response,:token_input_result).first
			  bank_account.bank_token = data[:token]
			  bank_account.last_four = data[:req_record_pan]
			  bank_account.account_type = params[:type_of_account]

			  if bank_account.bank_name.blank?
			  	bname =BankRouting.bank_name_from_routing(bank_account.routing)
			  	if bname != "NOT FOUND"
			  		bank_account.bank_name = bname
			  	end
			  end
			  #Grab the proper bank name from routing number table

			  if bank_account.save
			    context.bank_account = bank_account
			    return
			  else 
			  	context.bank_account = bank_account
			  	context.fail!
			  end

			rescue GulfApi::Client::GulfAPIError => e 
				bank_account.errors.add(:base, e.message)
				context.bank_account = bank_account
				context.fail!
				return

			end
   else
   	context.bank_account = bank_account
		  context.fail!
   end
		
	end

end