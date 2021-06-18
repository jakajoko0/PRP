module MailerHelper

	def bank_payment_status(bp)
    case bp.status
    when "pending"
      "The payment is awaiting transfer to the central bank."

    when "transit"
      "The payment has been submitted electronically to the central bank."
      
    when "error"      	
      "The payment encountered an error #{bp.note}"

    when "declined"
      "The payment has been DECLINED #{bp.note}"

    when "approved" 
      "The payment has been APPROVED on #{(I18n.l(bp.date_approved, format: :notime) if bp.date_approved)}"
    end
	end

  def card_payment_status(cp)
    case cp.status
    when "pending"
      "The payment was initiated."

    when "transit"
      "The payment is processing."
      
    when "error"        
      "The payment encountered an error #{cp.note}"

    when "declined"
      "The payment has been DECLINED #{cp.note}"

    when "approved" 
      "The payment has been APPROVED on #{(I18n.l(cp.date_approved, format: :notime) if cp.date_approved)}"
    end
  end

  def check_payment_status(cp)
    case cp.status
    when "pending"
      "The payment is pending"

    when "transit"
      "The payment is in transit to Home Office."
      
    when "declined"
      "The payment has been DECLINED #{cp.note}"

    when "approved" 
      "The payment has been APPROVED on #{(I18n.l(cp.date_approved, format: :notime) if cp.date_approved)}"
    end
  end


end