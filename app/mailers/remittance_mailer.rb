class RemittanceMailer < ApplicationMailer
  def remittance_reminder(franchise_id)
  	#Check if Franchise reported their royalties
    recipients = User.where("franchise_id = ?",franchise_id)
    emails = recipients.collect(&:email).join(",")
	  mail(to: emails, subject: 'Royalty Reminder' )
  end

end
