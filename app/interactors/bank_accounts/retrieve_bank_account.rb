class RetrieveBankAccount
	include Interactor

	def call
		bank_account = context.account
		gulf = GulfApi::Client.new(Rails.application.credentials.dig(:GULF_API_ID),Rails.application.credentials.dig(:GULF_API_KEY),Rails.application.credentials.dig(:GULF_GMS_ID))
		begin 
     response = gulf.retrieve_bank_token(bank_account.bank_token)
			  data = response.to_array(:token_output_response,:token_output_result).first
			  bank_account.account_number = ""
			  bank_account.type_of_account = data[:req_record_type]
			  bank_account.routing = data[:ach_routing]
			  bank_account.name_on_account = data[:req_record_name]
	      context.bank_account = bank_account
		    return

			rescue GulfApi::Client::GulfAPIError => e 
				bank_account.errors.add(:base, e.message)
				context.bank_account = bank_account
				context.fail!
				return
	 end

		
	end

end