class EmailSender
  ERRORS_TO_RESCUE = [
  	EOFError,
    IOError,
    TimeoutError,
    Errno::ECONNRESET,
    Errno::ECONNABORTED,
    Errno::EPIPE,
    Errno::ETIMEDOUT,
  	Net::SMTPAuthenticationError,
    Net::SMTPServerBusy,
    Net::SMTPSyntaxError,
    Net::SMTPFatalError,
    Net::SMTPUnknownError,
    Errno::ECONNREFUSED]

	def self.try_delivering_email(options = {}, &block)
		begin
			yield
			return true 
		rescue *ERRORS_TO_RESCUE => e 
			SmtpErrorMailer.send_error(e,options[:recip]).deliver_now
			return false
		end
	end
end