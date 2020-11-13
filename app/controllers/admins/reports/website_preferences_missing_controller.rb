class Admins::Reports::WebsitePreferencesMissingController < ReportController

def index

end

def report
  redirect_to admins_website_preferences_missing_path, notice: "Invalid Parameters" unless params_valid?
  sortby = params[:sortby]
  include_inactives = params[:inactives].to_i

  @franchises = WebsitePreferencesQuery.new.website_preferences_missing(include_inactives,sortby)
  sortby_text = sortby_title(sortby)
  
  title = format_report_title([I18n.t('reports.website_preferences_missing.title'),
                              sortby_text])
  title_excel = format_report_title_excel([I18n.t('reports.website_preferences_missing.title'),
                              sortby_text ])
  @report_info = {title: title, title_excel: title_excel}

  respond_to do |format|
    format.html
    format.pdf do 
      render pdf: "MissingWebsitePreferences",
      template: 'admins/reports/website_preferences_missing/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'A4',
      title: I18n.t('reports.website_preferences_missing.title'),
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment',
      margin: {top: 10}

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename='MissingWebsitePreferences.xlsx'"}
  end

end

private 
  def params_valid?
    params.has_key?(:inactives) && params.has_key?(:sortby)
  end
end

