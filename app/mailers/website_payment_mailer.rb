class WebsitePaymentMailer < ApplicationMailer

	def payment_method_notification(franchise_id)
  	#Check if 
    recipients = User.where("franchise_id = ?",franchise_id)
    emails = recipients.collect(&:email).join(",")
    #emails = "danielgrenier@bellsouth.net,brussell@smallbizpros.com"
	  mail(to: emails, subject: 'PR+P Website Payment Method' )
  end
end