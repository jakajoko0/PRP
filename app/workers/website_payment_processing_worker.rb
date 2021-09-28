class WebsitePaymentProcessingWorker
include Sidekiq::Worker
sidekiq_options retry: false

  def perform(current_month=Date.today.month, current_year=Date.today.year)
    #Process log, total number or cards and ach, approved and declined cards
    @process_log = []
    @card_total = 0
    @card_approved = 0
    @card_declined = 0
    @ach_total = 0
    @current_month = current_month
    @current_year = current_year

    #Setup the API client for Gulf
    gulf = GulfApi::Client.new
    
    #If Gulf is down, do not proceed
    if !gulf.system_check
      @process_log << ProcessingLog.new((I18n.l DateTime.now), "Could not Process Monthly Website Payments","Gulf Management System is Down!")
      TransmissionMailer.website_payments(process_log).deliver_now
      return 
    end
    
    #Add Starting Time and payment count to Processing Log
    @process_log << ProcessingLog.new((I18n.l DateTime.now), "Start of Website Payment Processing","")
    payment_count = WebsitePreference.count 
    @process_log << ProcessingLog.new((I18n.l DateTime.now), "We have #{payment_count} Payments to process","")
    
    puts "We have #{payment_count} Payments to process"
    puts "Generating Invoices"

     
    ActiveRecord::Base.transaction do
        #create transactions and invoices
        generate_web_payments
        #process card payments
        process_card_payments
        #create ach payments
        create_ach_payments
    

    rescue => e

      @process_log << ProcessingLog.new((I18n.l DateTime.now), "Error While Processing Website Payments","")
      @process_log << ProcessingLog.new((I18n.l DateTime.now), "",e.message)      
      raise ActiveRecord::Rollback
    ensure
      TransmissionMailer.website_payments(@process_log).deliver_now
    end  
    
  end

  private
  
  def generate_web_payments
    @process_log << ProcessingLog.new((I18n.l DateTime.now), "Generating Invoices","")      
    #Go through the list of current website plans for franchise owners
    WebsitePreferencesQuery.new.website_preferences_list_sorted("franchises.lastname ASC").each do |wp|
      #Setup the proper invoice code
      invoice_code = wp.website_preference == 1 ? '45' : '44'
      
      puts "Generating invoice for #{wp.franchise.franchise_number} #{wp.franchise.lastname} in the amount of #{wp.current_fee} "
      @process_log << ProcessingLog.new((I18n.l DateTime.now), "", "Generating invoice for #{wp.franchise.franchise_number} #{wp.franchise.lastname} in the amount of #{wp.current_fee} ")            
      #First we create an invoice unless it's there
      
      invoice = Invoice.where("franchise_id = ? AND EXTRACT('month' from date_entered) = ? AND EXTRACT('year' from date_entered) = ? AND admin_generated = ? AND invoice_type = ?", wp.franchise_id, @current_month, @current_year, 1 , 1)
      .first_or_create!(franchise_id: wp.franchise_id,
      date_entered: DateTime.now,
      paid: 0,
      note: "Recurring Billing for Website",
      admin_generated: 1,
      invoice_type: 1,
      invoice_items_attributes: [code: invoice_code, amount: wp.current_fee] )
      
      #Scroll and insert them into website_payments with status 0
      web_pay = WebsitePayment.where(franchise_id: wp.franchise_id,
                                year: @current_year, 
                                month: @current_month, 
                                invoice_id: invoice.id)
                                .first_or_create!(status: 0, fees: wp.current_fee, payment_type: wp.payment_method,  gms_token: wp.payment_token)
      @process_log << ProcessingLog.new((I18n.l DateTime.now),"", "Creating Website Payment Record and link it to Invoice")      
      puts "Creating Website Payment Record and link it to Invoice"
    end
  end
  
  def process_card_payments
    #Process Credit Card Payments First
    cards = WebsitePayment.card_payments_for(@current_year, @current_month)
    @card_total = cards.size
    puts "Processing #{@card_total} Credit Card payments"
    @process_log << ProcessingLog.new((I18n.l DateTime.now), "Processing #{@card_total} Credit Card payments","")      
    cards.each do |web_card_payment|

      #First we check if a card payment has been processed 
      #or is processing for this invoice already
      cp_there = CardPayment.where("franchise_id = ? 
      AND invoice_payment = ? 
      AND invoice_id = ? 
      AND status IN (?)", web_card_payment.franchise_id, 1, web_card_payment.invoice_id, [0,1,4])
      
      #If so, move on to the next one, we don't want to 
      #get 2 payments      
      next if cp_there.count.positive?

      cp = CardPayment.new
      cp.franchise_id= web_card_payment.franchise_id
      cp.date_entered= DateTime.now
      cp.payment_date= DateTime.now
      cp.invoice_payment= 1
      cp.invoice_id= web_card_payment.invoice_id
      cp.paid_with= CreditCard.get_description_from_token(web_card_payment.franchise_idm web_card_payment.gms_token)
      cp.amount= web_card_payment.fees
      cp.gms_token= web_card_payment.gms_token
      cp.status= "pending"
      cp.note= "Processing"
      
      if cp.save!
        #Process the card payment
        CardPaymentWorker.new.perform(cp.id)
       
        cp.reload
        
        if cp.status == "approved"
          @card_approved += 1
        else
          @card_declined += 1
        end
        puts "Payment Status for #{cp.franchise.number_and_name} : #{cp.note}"
        @process_log << ProcessingLog.new((I18n.l DateTime.now),"", "Payment Status for #{cp.franchise.number_and_name} : #{cp.note} ")      
      end
    end

    @process_log << ProcessingLog.new((I18n.l DateTime.now), "Approved Card Payments: #{@card_approved}  Declined Card Payments: #{@card_declined}","")      
    puts "Approved Card Payments: #{@card_approved}  Declined Card Payments: #{@card_declined}"
  end 

  def create_ach_payments
    #Insert ACH transactions after
    ach = WebsitePayment.ach_payments_for(@current_year, @current_month)
    @ach_total = ach.size
    
    @process_log << ProcessingLog.new((I18n.l DateTime.now), "Generating #{@ach_total} ACH payments","")      
    puts "Generating #{@ach_total} ACH payments"
    ach.each do |web_ach_payment|
      @process_log << ProcessingLog.new((I18n.l DateTime.now), "","Creating ACH Transaction for #{web_ach_payment.franchise.number_and_name} in the amount of #{web_ach_payment.fees}")      
      puts "Creating ACH Transaction for #{web_ach_payment.franchise.number_and_name} in the amount of #{web_ach_payment.fees}"
      
      ach_there = BankPayment.where("franchise_id = ? 
      AND invoice_payment = ? 
      AND invoice_id = ? 
      and status IN (?)", web_ach_payment.franchise_id, 1, web_ach_payment.invoice_id, [0,1,4])
      
      next if ach_there.count.positive?  
      
      pm = BankPayment.new
  
      # Populate the franchise specific info for the BankPayment
      pm.franchise_id = web_ach_payment.franchise_id
      pm.date_entered = DateTime.now
      pm.payment_date = DateTime.now
      pm.status = "pending"
      pm.invoice_payment = 1
      pm.invoice_id = web_ach_payment.invoice_id
      pm.paid_with = BankAccount.get_description_from_token(web_ach_payment.franchise_id, web_ach_payment.gms_token)
      pm.gms_token = web_ach_payment.gms_token 
      pm.amount = web_ach_payment.fees
      pm.note = "Awaiting Transfer"
        
      # Save the BankPayment
      if pm.save!
        begin
          BankPaymentMailer.status_change_notice(pm).deliver_now
        rescue Net::SMTPFatalError => e 
          ErrorMailer.error_message(e.message).deliver_now
        end  
      end
    end
  end
end