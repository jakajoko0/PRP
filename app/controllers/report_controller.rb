class ReportController < ApplicationController
  def sortby_title(sortby_value)
    I18n.t('reports.general.sorted_by', sortbytext: sortby_text(sortby_value))
  end

  def sortby_text(value)
    case value
    when 'franchises.franchise_number'
      "Franchise Number"
    when 'franchises.lastname'
      "Last Name"
    when 'franchises.state'  
      "State"  
    when 'website_preferences.updated_at'    
      "Last Modification"
    end
  end

  def include_title(flag)
    flag == 1 ? I18n.t('reports.general.including_inactives') : ""  
  end

  def format_report_title(title_text)
    html = title_text.join("<br>")
    html.html_safe
  end

  def format_report_title_excel(title_text)
    html = title_text.join("\r\n")
    html.html_safe
  end

end
  