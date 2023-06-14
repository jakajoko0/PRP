class Hubspot
  include HTTParty
 
  #################################################################################
  # This class uses the HTTParty gem to call WendPartners Hubspot sync endpoints
  #################################################################################
  URI='https://y5faq63qql.execute-api.us-east-1.amazonaws.com/dev/hsupdate'

  def synchronize(attributes)
    HTTParty.post(URI, body: attributes.to_json, headers: { 'Content-Type' => 'application/json' })
  end

end



