class WebsitePaymentMethodIssuesWorker
include Sidekiq::Worker
sidekiq_options retry: false

  def perform(current_month=Date.today.month, current_year=Date.today.year)
    issues_found = 0
    #Process log, total number or cards and ach, approved and declined cards
    process_log = []
    
    #Add Starting Time to Processing Log
    process_log << ProcessingLog.new((I18n.l DateTime.now), "Start of Website Payment Checkup","")
    #Get our Payment Count
    payment_count = WebsitePreference.count 
    
    process_log << ProcessingLog.new((I18n.l DateTime.now), "We have #{payment_count} Payments to verify","")

    #WebsiteOption.web_options_listing(2).each do |wo|
    WebsitePreferencesQuery.new.website_preferences_list_sorted("franchises.lastname ASC").each do |wp|
      
      #Find the Franchise
      fr = Franchise.find(wp.franchise_id)
      
      #Find Payment Method
      pm = wp.payment_method 
      puts "******************* Payment Method**** #{pm}"
      token = wp.payment_token 
      #If Bank, make sure the bank token exists for the Franchise
      if pm == "ach"
        if BankAccount.where(franchise_id: fr.id , bank_token: token ).count ==  0
          process_log << ProcessingLog.new((I18n.l DateTime.now), "","Bank Account for Franchise #{fr.franchise_number} #{fr.lastname} must be updated} ")      
          issues_found += 1
        end
      else
        #if Card, make sure the card token exists for the Franchise  
        if CreditCard.where(franchise_id: fr.id, card_token: token ).count == 0  
          process_log << ProcessingLog.new((I18n.l DateTime.now), "" , "Credit Card for Franchise #{fr.franchise_number} #{fr.lastname} must be updated ")      
          issues_found += 1
        else
          #Also, make sure the credit card they use is not expired
          cc = CreditCard.where(franchise_id: fr.id, card_token: token).first
          if cc.expired?
            process_log << ProcessingLog.new((I18n.l DateTime.now), "","Credit Card for Franchise #{fr.franchise_number} #{fr.lastname} has expired ")      
            issues_found += 1
          end
        
        end
      end
    end 

    if issues_found == 0
      process_log << ProcessingLog.new((I18n.l DateTime.now), "No Issues Found!","")      
    end

    TransmissionMailer.website_payments(process_log).deliver_now

  end
    
end
