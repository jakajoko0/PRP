class RemittanceMailer < ApplicationMailer
  def remittance_reminder(month, year)
  	#Check if Franchise reported their royalties
    recipients = franchises_without_royalties(month,year)
    emails = recipients.collect(&:email).join(",")
	  mail(bcc: emails, subject: 'Royalty Reminder' )
  end

  private 
  
  def franchises_without_royalties(month,year)
  	User.all_active.where("franchise_id NOT IN (SELECT franchise_id FROM remittances WHERE year = ? and month = ?)", year, month)
  end

end
