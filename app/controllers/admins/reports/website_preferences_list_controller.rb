class Admins::Reports::WebsitePreferencesListController < ReportController

def index

end

def report
  redirect_to admins_franchise_list_path unless params.has_key?(:sortby)
  sortby = params[:sortby]

  @website_preferences = WebsitePreferencesQuery.new.website_preferences_list_sorted(sortby)
  basic = @website_preferences.select{|wp| wp.website_preference == 0}.count
  custom = @website_preferences.select{|wp| wp.website_preference == 1}.count
  special = @website_preferences.select{|wp| wp.website_preference == 2}.count
  sortby_text = sortby_title(sortby)
  
  title = format_report_title([I18n.t('reports.website_preferences_list.title'),
                              sortby_text])
  title_excel = format_report_title_excel([I18n.t('reports.website_preferences_list.title'),
                              sortby_text ])
  @report_info = {title: title, title_excel: title_excel, basic: basic, custom: custom, special: special }

  respond_to do |format|
    format.html
    format.pdf do 
      render pdf: "WebsitePreferencesList",
      template: 'admins/reports/website_preferences_list/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.website_preferences_list.title'),
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename='WebsitePreferencesList.xlsx'"}
  end

end
end

