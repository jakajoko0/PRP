class ApplicationMailer < ActionMailer::Base
  default from: 'PR+P USA <padgettportal@smallbizpros.com>'
  layout 'mailer'
  
  ERRORS_TO_RESCUE = [
    Net::SMTPAuthenticationError,
    Net::SMTPServerBusy,
    Net::SMTPSyntaxError,
    Net::SMTPFatalError,
    Net::SMTPUnknownError,
    Errno::ECONNREFUSED
  ]
  
  
  rescue_from *ERRORS_TO_RESCUE do |exception|
    # Handle it here
    SmtpErrorMailer.send_error(exception, message.to).deliver_now
    
  end
 
end
