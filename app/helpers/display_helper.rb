module DisplayHelper
  REGIONS = {1 => "Southeast", 2 => "Mid-Atlantic", 
             3 => "Northeast Corridor", 4 => "Mid-USA",
             5 => "West", 19 => "Processing Center",
             20 =>  "Corporate", 0 => "Home Office" }
  

  #Throughout the app, we have the same links to 
#Edit, Show, Delete with the same icons
#This helper was created to minimize code in the view
def link_with_icon(link, action, description,confirm="",turbo=true)
  case action 
  when "show"
    a_tag = <<-HTML
    <a data-turbolinks="#{turbo}" 
       href="#{link}" 
       class="show-link">
    <i class="far fa-file-alt fa-2x padgett-blue-icon" 
    aria-hidden="true" 
    data-html = "true" 
    data-toggle="tooltip" 
    title="#{description}">
    </i>
    </a>
    HTML
  when "invoice"
    a_tag = <<-HTML
    <a data-turbolinks="#{turbo}" 
       href="#{link}" 
       class="show-link">
    <i class="fa fa-file-invoice-dollar fa-2x padgett-blue-icon" 
    aria-hidden="true" 
    data-html = "true" 
    data-toggle="tooltip" 
    title="#{description}">
    </i>
    </a>
    HTML
  when "edit"
    a_tag = <<-HTML
    <a data-turbolinks="#{turbo}" href="#{link}" class = "edit-link">
    <i class="fas fa-edit fa-2x padgett-blue-icon" 
    aria-hidden="true" 
    data-html = "true" 
    data-toggle="tooltip" 
    title="#{description}">
    </i>
    </a>
    HTML
  when "audit"   
   a_tag = <<-HTML
    <a data-turbolinks="#{turbo}" href="#{link}" class = "audit-link">
    <i class="fas fa-eye fa-2x padgett-blue-icon" 
    aria-hidden="true" 
    data-html = "true" 
    data-toggle="tooltip" 
    title="#{description}">
    </i>
    </a>
    HTML
  when "delete" 
    a_tag = <<-HTML
    <a data-confirm="#{confirm}" rel="nofollow" data-method="delete" href="#{link}" class="delete-link">
    <i class="far fa-trash-alt fa-2x padgett-blue-icon" 
    aria-hidden="true" 
    data-html = "true" 
    data-toggle="tooltip" 
    title="#{description}">
    </i>
    </a>
    HTML
  when "details" 
    a_tag = <<-HTML
    <a data-turbolinks="#{turbo}"
       href="#{link}">
    <i class="fas fa-list fa-2x padgett-blue-icon" 
    aria-hidden="true" 
    data-html = "true" 
    data-toggle="tooltip" 
    title="#{description}">
    </i>
    </a> 
    HTML
  end 
  a_tag.html_safe
end

def description_peek(description, location)
  i_tag = <<-HTML
  <i class = "far fa-comment fa-2x"
  aria-hidden="true"
  data-html="true"
  data-toggle="tooltip"
  title ="#{description}"
  data-placement="#{location}"
  data-container="body">
  </i>
  HTML
  i_tag.html_safe
end

def bubble_help(help_description,location)
  i_tag = <<-HTML
  <i class = "far fa-question-circle"
  aria-hidden="true"
  data-html="true"
  data-toggle="tooltip"
  title ="#{help_description}"
  data-placement="#{location}"
  data-container="body">
  </i>
  HTML
  i_tag.html_safe
end

def display_checkmark(value = 0, description = "")
  if value == 1 || value == true
    i_tag = <<-HTML 
    <i class="far fa-check-circle fa-2x padgett-green-icon" 
    aria-hidden="true"
    data-html = "true" 
    data-toggle="tooltip" 
    title="#{description}" >
    </i>
    HTML
  else
    i_tag = ""
  end
  i_tag.html_safe

end

def region_desc(region)
  REGIONS.fetch(region)
end

def prp_transaction_destination(admin = 0, trans)
  path = ""
  special = ["Charge", "Credit"]
  if special.include?(trans.transactionable_type)
 
    path = "/#{trans.transactionable_type.downcase.pluralize}/#{trans.id}"

    path = admin == 1 ? "/admins"+path : path
  else
    path = polymorphic_path([:admins, trans.transactionable])
  end

  path



end


def format_audited_events(audits)
  html = ""
  audits.audited_changes.each do |key,val|
    html = html += "<strong>#{key.titleize}</strong>"
    html = html += " #{I18n.t('audit.was_changed')} "
    if val.class == Array 
      html = html += "#{I18n.t('audit.from_to', former_value: val[0], new_value: val[1])}"
    else
      html = html += "#{I18n.t('audit.to', value: val)}"
    end
    html = html += "<br>"
  end

  html.html_safe
end

def link_to_add_franchise_group_fields(name, f, association, display_class)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
       
    link_to(name, '#', class: "#{display_class} add_items", id: "franchise_group_add_item_button", data: {id: id, fields: fields.gsub("\n", "")})
  end

def unformatted_audited_events(audits)
  txt = ""
  audits.audited_changes.each do |key,val|
    txt = txt+= "#{key.titleize}"
    txt = txt += " #{I18n.t('audit.was_changed')} "
    if val.class == Array 
      txt = txt += "#{I18n.t('audit.from_to', former_value: val[0], new_value: val[1])}"
    else
      txt = txt += "#{I18n.t('audit.to', value: val)}"
    end
    txt = txt += "\x0D\x0A"
  end
  txt
end

def payment_method_type(type)
  type == 'C' ? "Credit Card" : "ACH"
end

def payment_method_name(type,name)
  type == 'B' ? name : credit_card_type(name)
end

def credit_card_type(type)
  case type
  when 'V' then 'Visa'
  when 'M' then 'MasterCard'
  when 'I' then 'Discover'  
  when 'A' then 'American Express'
  end
end

def franchise_select_options()
  frans = Franchise.franchise_list_with_consol_flag
  frans.map do |fran|
    html_attributes = {}
    html_attributes['style'] = 'color:blue' if fran.consol >0
    display_value = fran.dropdown_list+ (fran.consol > 0 ? " **" : "")
    [display_value, fran.id, html_attributes]
  end
end


end