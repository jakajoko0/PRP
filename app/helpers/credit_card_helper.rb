module CreditCardHelper
  def card_status(card)
  	rtn_html = ""
    if card.expired?
  			rtn_html = <<-HTML
        <i class="fas fa-exclamation-circle fa-2x attention-icon" 
        aria-hidden="true" 
        data-html = "true" 
        data-toggle="tooltip" 
        title="#{I18n.t('credit_card.index.has_expired')}"
        data-placement = "right" data-container="body">
       </i>
       HTML
    else
      if card.expiring?
        rtn_html = <<-HTML
        <i class="fas fa-exclamation-circle fa-2x warning-icon" 
        aria-hidden="true" 
        data-html = "true" 
        data-toggle="tooltip" 
        title="#{I18n.t('credit_card.index.is_expiring')}"
        data-placement = "right" data-container="body">
       </i>
       HTML
      end
    end  

    rtn_html.html_safe    
  
  end

  def destination_button(destination,franchise, pct_width)
    rtn_html = ""
    route = ""
      case destination 
      when 'add_royalty'
        route = new_remittance_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.enter_royalty')
      when 'add_receivable'
        route = new_receivable_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.add_charge')
      when 'add_invoice'
        route = new_invoice_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.add_invoice')
      when 'add_payment'
        route = new_check_payment_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.enter_check')
      when 'add_credit'
        route = new_franchise_credit_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.enter_credit')
      when 'add_accountant'
        route = new_admins_accountant_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.add_accountant')
      when 'support'
        route = supports_path(franchise_id: franchise.id)
      when 'add_insurance'
        route = new_admins_insurance_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.add_insurance')
      end

      rtn_html = <<-HTML     
        <td class = "text-nowrap" width="#{pct_width}%" style="text-align:right">
          <a data-turbolinks="false" href="#{route}" class="btn btn-sm btn-padgett">#{button_text}</a>
        </td>
      HTML
    
    rtn_html.html_safe
  end
end