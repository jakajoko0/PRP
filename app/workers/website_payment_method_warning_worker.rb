class WebsitePaymentMethodWarningWorker
include Sidekiq::Worker
sidekiq_options retry: false

  def perform(current_month=Date.today.month, current_year=Date.today.year)
    issues_found = 0
    
    WebsitePreferencesQuery.new.website_preferences_list_sorted("franchises.lastname ASC").each do |wp|

      issues_found = 0

      #Find the Franchise
      fr = Franchise.find(wp.franchise_id)
      #Find Payment Method
      pm = wp.payment_method 
      
      token = wp.payment_token 
      #If Bank, make sure the bank token exists for the Franchise
      if pm == "ach"
        if BankAccount.where(franchise_id: fr.id , bank_token: token ).count ==  0
          issues_found += 1
        end
      else
        #if Card, make sure the card token exists for the Franchise  
        if CreditCard.where(franchise_id: fr.id, card_token: token ).count == 0  
          issues_found += 1
        else
          #Also, make sure the credit card they use is not expired
          cc = CreditCard.where(franchise_id: fr.id, card_token: token).first
          if cc.expired?
            issues_found += 1
          end
        
        end
      end

      if issues_found > 0 
        WebsitePaymentMailer.payment_method_notification(fr.id).deliver_now
      end
    end

  end
    
end
