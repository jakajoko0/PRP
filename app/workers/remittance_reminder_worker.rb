class RemittanceReminderWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false 

  def perform
  
    #Find the cutoff date for royalties for this month
    target_date = DateUtils.find_cutoff_date
    today = Date.today
    last_month = Date.today-1.month
  

    #If we are already passed the cutoff date, dont bother sending a reminder
    return false if (today >= target_date)
  
    #From that cutoff date, find the warning date
    warning_date = DateUtils.find_warning_date(target_date)
    
    if today == warning_date
      RemittanceMailer.remittance_reminder(last_month.month,last_month.year).deliver_now
    end 
  end	
end

    

