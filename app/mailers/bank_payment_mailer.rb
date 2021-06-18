class BankPaymentMailer < ApplicationMailer
  helper :mailer

	def status_change_notice(bank_payment)
	  @bank_payment = bank_payment
    recipients = User.where("franchise_id = ?", @bank_payment.franchise_id)
	  emails = recipients.collect(&:email).join(",")
    subject = ach_subject(@bank_payment.status)

	  mail(to: emails, subject: subject)
  end

	def updated_notice(bank_payment)
	  @bank_payment = bank_payment
    recipients = User.where("franchise_id = ?", @bank_payment.franchise_id)
    emails = recipients.collect(&:email).join(",")
    subject = "ACH Payment Updated"

	  mail(to: emails, subject: subject)
  end    

  def delete_notice(bank_payment)
    @bank_payment = bank_payment
	  recipients = User.where("franchise_id = ?", @bank_payment.franchise_id)
    emails = recipients.collect(&:email).join(",")
    subject = "ACH Payment Deleted"
	  
	  mail(to: emails, subject: subject)
	end


	private 
    def ach_subject(status)
      case status
      when "pending"
        "ACH Payment Created"
      when "transit"
        "ACH Payment Transfer"
      when "error"
        "ACH Payment Error"
      when "declined"
        "ACH Payment Declined"
      when "approved"
        "ACH Payment Approved"
      end
    end
end