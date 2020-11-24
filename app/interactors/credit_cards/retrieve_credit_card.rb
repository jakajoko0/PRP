class RetrieveCreditCard
	include Interactor

	def call
		credit_card = context.account
		gulf = GulfApi::Client.new
		begin 
     response = gulf.retrieve_card_token(credit_card.card_token)
			  data = response.to_array(:token_output_response,:token_output_result).first
			  credit_card.cc_number = ""
			  credit_card.cc_type = data[:req_record_type]
			  credit_card.cc_exp_month = data[:crd_expiration_mm]
			  credit_card.cc_exp_year = data[:crd_expiration_yy]
			  credit_card.cc_name = data[:req_record_name]
			  credit_card.cc_address = data[:op_address]
			  credit_card.cc_city = data[:op_city]
			  credit_card.cc_state = data[:op_state]
			  credit_card.cc_zip = data[:op_zip]
	      context.credit_card = credit_card
		    return

			rescue GulfApi::Client::GulfAPIError => e 
				credit_card.errors.add(:base, e.message)
				context.credit_card = credit_card
				context.fail!
				return
	 end

		
	end

end