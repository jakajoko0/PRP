class CardPaymentMailer < ApplicationMailer
  helper :mailer

	def status_change_notice(card_payment)
	  @card_payment = card_payment
    recipients = User.where("franchise_id = ?", @card_payment.franchise_id)
	  emails = recipients.collect(&:email).join(",")
    subject = card_subject(@card_payment.status)

	  mail(to: emails, subject: subject)
  end

	
	private 
    def card_subject(status)
      case status
      when "pending"
        "Card Payment Pending"
      when "transit"
        "Card Payment Processing"
      when "error"
        "Card Payment Error"
      when "declined"
        "Card Payment Declined"
      when "approved"
        "Card Payment Approved"
      end
    end
end