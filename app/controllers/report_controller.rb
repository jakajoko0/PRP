class ReportController < ApplicationController
  def sortby_title(sortby_value)
    I18n.t('reports.general.sorted_by', sortbytext: sortby_text(sortby_value))
  end

  def sortby_text(value)
    case value
    when 'franchise_number'
      "Franchise Number"
    when 'lastname'
      "Last Name"
    end
  end

  def include_title(flag)
    flag == 1 ? I18n.t('reports.general.including_inactives') : ""  
  end

  def format_report_title(*title_text)
    html = ""
    title_text.each do |text|
      html = html+text+"<br>" if !text.blank?
    end
    html.html_safe
  end

end
  