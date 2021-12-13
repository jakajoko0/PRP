class SmtpErrorMailer < ApplicationMailer
  
  def send_error(exception,recips)
  	@msg = exception.message
  	@faulty_recipients = recips
  	recip = 'danielgrenier@bellsouth.net'
    mail(to: recip, subject: 'SMTP Rescued Error in PR+P USA' )

  end

end