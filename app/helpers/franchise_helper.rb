module FranchiseHelper

  def franchise_consolidation_status(fran)
    rtn_html = ""
    if fran.consolidated? || fran.consolidator? 
        rtn_html += <<-HTML
        <i class = "fas fa-sitemap fa-2x padgett-blue-icon"
        aria-hidden = "true"
        data-html = "true"
        data-toggle = "tooltip"
        title = "#{fran.consolidation_status}"
        data-placement = "right"
        data-container = "body">
      </i>
      HTML

    end

    rtn_html.html_safe    

  end
  def franchise_status(fran)
  	rtn_html = ""
  	if fran.non_compliant == 1 
  		rtn_html += <<-HTML
        <i class="fas fa-exclamation-circle fa-2x attention-icon" 
        aria-hidden="true" 
        data-html = "true" 
        data-toggle="tooltip" 
        title="Non Compliant#{fran.non_compliant_reason.blank? ? '' : ' ('+fran.non_compliant_reason+')'} "
        data-placement = "right" data-container="body">
       </i>
       HTML
    end  

    if fran.inactive == 1
    	rtn_html += <<-HTML
        <i class="fas fa-user-times fa-2x attention-icon" 
        aria-hidden="true" 
        data-html = "true" 
        data-toggle="tooltip" 
        title="Inactive#{fran.term_reason.blank?  ? '' : ' ('+fran.term_reason+')' } "
        data-placement = "right" data-container="body">
       </i>
       HTML
    end
    

    if fran.term_date && fran.term_date <= Date.today 
    	rtn_html += <<-HTML
        <i class="fas fa-calendar-times fa-2x attention-icon" 
        aria-hidden="true" 
        data-html = "true" 
        data-toggle="tooltip" 
        title="Terminated On #{(l fran.term_date)} #{fran.term_reason.blank? ? '' : ' ('+fran.term_reason+')'}" 
        data-placement = "right" data-container="body">
       </i>
       HTML
    end

    if rtn_html == ""
      rtn_html = <<-HTML
        <i class="far fa-check-circle fa-2x padgett-green-icon" 
        aria-hidden="true" 
        data-html = "true" 
        data-toggle="tooltip" 
        title="In Compliance" 
        data-placement = "right" data-container="body">
       </i>
       HTML
    end
    rtn_html.html_safe    
  
  end

  def destination_button(destination,franchise, pct_width)
    rtn_html = ""
    route = ""
      case destination 
      when 'add_financial'  
        route = new_admins_financial_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.enter_financial')
      when 'add_royalty'
        route = new_admins_remittance_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.enter_royalty')
      when 'add_website_preference'
        route = new_admins_website_preference_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.new_website_pref')
      when 'add_charge'
        route = new_admins_charge_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.add_charge')
      when 'add_invoice'
        route = new_admins_invoice_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.add_invoice')
      when 'add_check'
        route = new_admins_check_payment_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.enter_check')
      when 'add_credit'
        route = new_admins_credit_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.enter_credit')
      when 'add_accountant'
        route = new_admins_accountant_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.add_accountant')
      when 'support'
        route = supports_path(franchise_id: franchise.id)
      when 'add_insurance'
        route = new_admins_insurance_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.add_insurance')
      when 'add_document'  
        route = new_admins_franchise_document_path(franchise_id: franchise.id)
        button_text = I18n.t('franchise_select.add_document')
      end
      rtn_html = <<-HTML     
        <td class = "text-nowrap" width="#{pct_width}%" style="text-align:right">
          <a data-turbolinks="false" href="#{route}" class="btn btn-sm btn-padgett">#{button_text}</a>
        </td>
      HTML
    
    rtn_html.html_safe
  end

  def link_to_add_consolidation_fields(name, f, association, display_class)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
       
    link_to(name, '#', class: "#{display_class} add_items", id: "franchises_add_item_button", data: {id: id, fields: fields.gsub("\n", "")})
  end
end