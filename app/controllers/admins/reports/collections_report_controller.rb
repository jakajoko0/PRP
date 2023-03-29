class Admins::Reports::CollectionsReportController < ReportController

def index

end


def report
  redirect_to admins_collections_report, notice: "Invalid parameters" unless params_valid?
  redirect_to admins_collections_report_path, notice: "Invalid dates. Please check date formats" unless dates_valid?
  @start_date = Date.strptime(params[:start_date], I18n.translate('date.formats.default'))
  @end_date = Date.strptime(params[:end_date], I18n.translate('date.formats.default'))
  @consolidate = params[:consolidation].to_i
  @results = []
  consol_list = FranchiseConsolidation.all_franchises
  consol_text = @consolidate == 1 ? "Yes" : "No"

  @collections = RemittancesQuery.new.collections_by_date_range(@start_date, @end_date, @consolidate, consol_list )

  total_collections = @collections.reduce(0) { |sum,f| sum + f.tot_collect}
  total_royalty = @collections.reduce(0) { |sum,f| sum + f.royalty}
  total_collections == 0.00 ?  pct = 0.00 :  pct = ((total_royalty * 100) / total_collections).round(2)

  title = format_report_title([
    I18n.t('reports.collections_report.title', start: 
      (I18n.l @start_date), end: (I18n.l @end_date)),
    I18n.t('reports.collections_report.title2', consol: consol_text)])
  title_excel = format_report_title_excel([
    I18n.t('reports.collections_report.title', start: 
      (I18n.l @start_date), end: (I18n.l @end_date)),
    I18n.t('reports.collections_report.title2', consol: consol_text)])
  @report_info = {title: title, title_excel: title_excel, total_collections: total_collections, total_royalty: total_royalty, total_pct: pct }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "Collections",
      template: 'admins/reports/collections_report/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.collections_report.title_excel'),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment',
      enable_local_file_access: true

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=Collections.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:start_date) && params.has_key?(:end_date) && params.has_key?(:consolidation)
  end

  def dates_valid?
    begin
      Date.strptime(params[:start_date], I18n.translate('date.formats.default'))
      Date.strptime(params[:end_date], I18n.translate('date.formats.default'))
    rescue ArgumentError
      return false
    end
    true
  end
end

