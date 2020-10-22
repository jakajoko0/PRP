module GulfApi
  class Client
  	API_ENDPOINT = "https://www.gms-operations.com/webservices/ACHPayorService/ACHPayorService.asmx?WSDL"
	  attr_reader :api_id
		attr_reader :api_key
		attr_reader :gms_id
    
    GulfAPIError = Class.new(StandardError)
			
		HTTP_ERRORS = [
  		EOFError,
  		SocketError,
  		Errno::ECONNRESET,
  		Errno::EINVAL,
	 		Errno::ECONNREFUSED, 
  		Errno::EHOSTUNREACH, 
  		Net::HTTPBadResponse,
  		Net::HTTPHeaderSyntaxError,
  		Net::ProtocolError,
  		Timeout::Error,
  		Savon::HTTPError,
  		Savon::SOAPFault,
  		Savon::UnknownOperationError,
  		HTTPI::SSLError
		]
			
		def initialize(api_id, api_key, gms_id)
			@api_id = api_id
			@api_key = api_key
			@gms_id = gms_id
		end

		def system_check
			begin 
			  response = client.call(:system_check, message: {'api_id' => @api_id, 'api_key' => @api_key, 'gms_id' => @gms_id})
			  if response.success?
			  	data = response.to_array(:system_check_response,:system_check_result).first
					return data[:stat] == true 
			  else
					return false					  	
				end

			rescue *HTTP_ERRORS => error 
				return false 
			end
		end

		def retrieve_bank_token(token)
			response = request('token_output',{'token' => token})
		end

		def create_bank_token(token, token_type, routing, account_holder, account_number)
			response = request('token_input', {'token' => token, 'token_type' => token_type, 'routing' => routing, 'name' => account_holder, 'acct_cc_number' => account_number })
		end

		def create_card_token(token, token_type, expiration_month, expiration_year, customer_name, card_number, address = "", city = "", state = "", zip_code = "" )
		  response = request('token_input', {'token' => token, 'token_type' => token_type, 
		  'expiration_month' => expiration_month, 'expiration_year' => expiration_year,
		  'name' => customer_name, 'acct_cc_number' => card_number, 'address' => address,
		  'city' => city, 'state' => state, 'zip' => zip_code})	
		end

		def retrieve_card_token(token)
			response = request('token_output', {'token' => token})
		end

		private 

		def client 
			Savon.client(raise_errors: false,
       wsdl:API_ENDPOINT,
       open_timeout: 30,
       read_timeout: 30)
		end

		def request(some_name, params)
			#Check if the system is online and not erroring out
			if system_check
				response = client.call(some_name.to_sym, message: params.merge({'api_id' => @api_id, 'api_key' => @api_key, 'gms_id' => @gms_id}))
				if response.success?
					return response
				else		
				  if response.soap_fault.present?
					  error = Hash.from_xml(response.soap_fault.to_s)
					  raise GulfAPIError , error["Error"]["ErrorMessage"]
				  end 
				end
			else
			  raise GulfAPIError, "Payment Server is unreachable at this moment"	
			end	
		end
	end
end
