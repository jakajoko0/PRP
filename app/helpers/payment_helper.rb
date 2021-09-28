module PaymentHelper
  #Helper that displays the proper payment icon
  #depending on the payment type
  
  def paid_with_icon(payment)
    case payment.type
    when 'CardPayment'
      rtn_html = "<i class='far fa-credit-card fa-2x padgett-blue-icon'"
    when 'BankPayment'
      rtn_html = "<i class='fas fa-university fa-2x padgett-blue-icon'"
    when 'CheckPayment'
      rtn_html = "<i class='far fa-envelope fa-2x padgett-blue-icon'"
    end
  
    (rtn_html += "aria-hidden='true' data-html = 'true' data-toggle='tooltip' title='#{payment.paid_with}' data-placement ='right' data-container='body'></i>").html_safe
  end

  def cardicon
    ("<i class='far fa-credit-card fa-2x padgett-blue-icon'' aria-hidden='true' data-html = 'true' data-toggle='tooltip' data-placement ='right' data-container='body'></i>").html_safe
  end

  def bankicon
    ("<i class='fas fa-university fa-2x padgett-blue-icon' aria-hidden='true' data-html = 'true' data-toggle='tooltip' data-placement ='right' data-container='body'></i>").html_safe
  end

  #Helper that displays the proper payment status icon
  #depending on the payment type
  def payment_status_icon(payment)
    case payment.status
    when "pending"
    	if payment.type == 'CardPayment'
  	    "<i class='fas fa-spinner fa-pulse fa-2x' aria-hidden='true'></i>".html_safe	
  	  else
    		"<i class='far fa-hourglass fa-2x padgett-blue-icon' aria-hidden='true'></i>".html_safe
    	end
    when "transit" 
      "<i class='fas fa-cloud-upload-alt fa-2x padgett-blue-icon' aria-hidden='true'></i>".html_safe
    when "error"
      "<i class='fas fa-exclamation-triangle fa-2x padgett-blue-icon' aria-hidden='true'></i>".html_safe    
    when "declined"
    	"<i class='far fa-thumbs-down fa-2x padgett-blue-icon' aria-hidden='true'></i>".html_safe
    when "approved" 
    	"<i class='far fa-thumbs-up fa-2x padgett-blue-icon' aria-hidden='true'></i>".html_safe
    end
  end

  def web_payment_status(status)
    case status.to_sym
    when :pending 
      "<i class='far fa-hourglass fa-2x padgett-blue-icon' aria-hidden='true'></i>".html_safe
    when :processing
      "<i class='fas fa-cloud-upload-alt fa-2x padgett-blue-icon' aria-hidden='true'></i>".html_safe
    when :processed
      "<i class='far fa-thumbs-up fa-2x padgett-green-icon' aria-hidden='true'></i>".html_safe
    when :declined
      "<i class='fas fa-exclamation-triangle fa-2x attention-icon' aria-hidden='true'></i>".html_safe    
    end
  end
end