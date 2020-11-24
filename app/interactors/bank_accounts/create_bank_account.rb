class CreateBankAccount
	include Interactor

	def call
		bank_account = BankAccount.new(context.params)
		if bank_account.valid? && bank_account.errors.empty?
			gulf = GulfApi::Client.new

			begin 
			  response = gulf.create_bank_token(bank_account.bank_token,
				  	                     bank_account.type_of_account,
				  	                     bank_account.routing,
				  	                     bank_account.name_on_account,
				  	                     bank_account.account_number)
			  data = response.to_array(:token_input_response,:token_input_result).first
			  bank_account.bank_token = data[:token]
			  bank_account.last_four = data[:req_record_pan]
			  bank_account.account_type = bank_account.type_of_account

			  if bank_account.bank_name.blank? 
			  	#Grab the proper bank name from routing number table
			  	bname = BankRouting.bank_name_from_routing(bank_account.routing)
			  	if bname != "NOT FOUND"
			  		bank_account.bank_name = bname
			  	end
			  end 

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