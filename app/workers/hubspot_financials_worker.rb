class HubspotFinancialsWorker
include Sidekiq::Worker
sidekiq_options :retry => true 
# This is the Hubspot Financial Worker. It's listening for financial record changes (new or updateds)
# And will call a webhook with the financial record attributes to be updated in Hubspot

  def perform(change_hash)
    fr_id = change_hash["franchise_id"]
    fr = Franchise.find(fr_id.to_i)
    change_hash["franchise_number"] = fr.franchise_number
    Sidekiq.logger.warn "Sending the following hash to Hubspot: #{change_hash}"
    begin
      response = Hubspot.new.synchronize(change_hash)
      case response.code
      when 200
        Sidekiq.logger.warn "Hubspot called successfuly"
      else
        Sidekiq.logger.warn("Error Calling Hubspot Sync: #{response.code} - #{response.body}")
      end
    rescue HTTParty::Error => e
      Sidekiq.logger.warn("Error Calling Hubspot Sync: HTTParty::Error (#{e.message}")
    rescue StandardError => e
      Sidekiq.logger.warn("Error Calling Hubspot Sync: StandardError::Error (#{e.message}")        
    end
  end

end
