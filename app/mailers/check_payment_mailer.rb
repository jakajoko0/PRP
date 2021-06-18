class CheckPaymentMailer < ApplicationMailer
  helper :mailer

	def status_change_notice(check_payment)
	  @check_payment = check_payment
    recipients = User.where("franchise_id = ?", @check_payment.franchise_id)
	  emails = recipients.collect(&:email).join(",")
    subject = check_subject(@check_payment.status)

	  mail(to: emails, subject: subject)
  end

	def updated_notice(check_payment)
	  @check_payment = check_payment
    recipients = User.where("franchise_id = ?", @check_payment.franchise_id)
    emails = recipients.collect(&:email).join(",")
    subject = "Check Payment Updated"

	  mail(to: emails, subject: subject)
  end    

  def delete_notice(check_payment)
    @check_payment = check_payment
	  recipients = User.where("franchise_id = ?", @check_payment.franchise_id)
    emails = recipients.collect(&:email).join(",")
    subject = "Check Payment Deleted"
	  
	  mail(to: emails, subject: subject)
	end


	private 
    def check_subject(status)
      case status
      when "pending"
        "Check Payment Created"
      when "transit"
        "Check Payment in Transit"
      when "declined"
        "Check Payment Declined"
      when "approved"
        "Check Payment Approved"
      end
    end
end