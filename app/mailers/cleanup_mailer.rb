class CleanupMailer < ApplicationMailer

  def cleanup_notification(documents_cleaned)
  	@documents_cleaned = documents_cleaned
    mail(to: 'dgrenier@smallbizpros.com', subject: "Attachments Cleaned Up")	
  end
end