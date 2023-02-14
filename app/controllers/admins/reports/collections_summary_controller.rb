class Admins::Reports::CollectionsSummaryController < ReportController

def index

end

def report
  return redirect_to admins_collections_by_year_path, notice: "Invalid parameters" unless params_valid?
  
  @results = []
  from_month = params[:month]
  from_year = params[:year]
  to_month = params[:month2]
  to_year = params[:year2]

  month1 = from_month[:selected_month].to_i
  year1 = from_year[:selected_year].to_i
  month2 = to_month[:selected_month].to_i
  year2 = to_year[:selected_year].to_i
  
  @results = RemittancesQuery.new.collections_and_royalties_by_year(year1, month1, year2, month2)
  Rails.logger.debug "RESULTS: #{@results.inspect}"
  total_collections = @results.reduce(0) { |sum,f| sum + f.tot_collect}
  Rails.logger.debug "TOTAL COLLECTIONS: #{total_collections}" 
  title = format_report_title([
    I18n.t('reports.collections_summary_year.title'),
    I18n.t('reports.collections_summary_year.title2', 
      date1: "#{Date::MONTHNAMES[month1]} #{year1}",
      date2: "#{Date::MONTHNAMES[month2]} #{year2}")])
  title_excel = format_report_title_excel([
    I18n.t('reports.collections_summary_year.title'),
    I18n.t('reports.collections_summary_year.title2', 
      date1: "#{Date::MONTHNAMES[month1]} #{year1}",
      date2: "#{Date::MONTHNAMES[month2]} #{year2}")])
  @report_info = {title: title, title_excel: title_excel, total_collections: total_collections }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "Collections Summary by Year",
      template: 'admins/reports/collections_summary_by_year/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.collections_summary_year.title_excel'),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment',
      enable_local_file_access: true

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=CollectionsSummaryByYear.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:month) && params.has_key?(:year) && params.has_key?(:year2) && params.has_key?(:month2)
  end
end

