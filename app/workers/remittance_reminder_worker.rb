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
      franchises_to_email = franchises_without_royalties(last_month.month, last_month.year)
      franchises_to_email.each do |fr| 
        RemittanceMailer.remittance_reminder(fr.franchise_id).deliver_now
      end 
    end
  end	

  private

  def franchises_without_royalties(month,year)
    User.all_active.select("franchise_id").where("franchise_id NOT IN (SELECT franchise_id FROM remittances WHERE year = ? and month = ?)", year, month).distinct
  end

end

    

