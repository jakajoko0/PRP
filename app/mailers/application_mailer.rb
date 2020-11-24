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

  rescue_from *ERRORS_TO_RESCUE  do |exception|
  	redirect_to root_path, notice: "An error occured while trying to send email notification"
  end

end
