class Admins::Reports::CollectionsThresholdController < ReportController

def index

end


def report
  return redirect_to admins_collections_threshold_path, notice: "Invalid parameters" unless params_valid?
  return redirect_to admins_collections_threshold_path, notice: "Enter Threshold" if params[:threshold].blank?
  
  from_month = params[:month]
  from_year = params[:year] 
  to_month = params[:month2]
  to_year = params[:year2]
  amount = params[:threshold].to_f
  orderby = params[:sortby].to_i

  case orderby
  when 1
    ordertext = I18n.t('reports.general.sort_by_lastname')
  when 2
    ordertext = I18n.t('reports.general.sort_by_fran')
  when 3
    ordertext = I18n.t('reports.general.sort_by_total_collected')
  end
  
  month1 = from_month[:selected_month].to_i
  year1 = from_year[:selected_year].to_i
  month2 = to_month[:selected_month].to_i
  year2 = to_year[:selected_year].to_i
  
  @results = RemittancesQuery.new.collections_under_threshold(year1,month1, year2, month2,amount,orderby)
    
  title = format_report_title([
    I18n.t('reports.collections_threshold.title', amount: 
      amount),
    I18n.t('reports.collections_threshold.title2', start: "#{Date::MONTHNAMES[month1]} #{year1}", end: "#{Date::MONTHNAMES[month2]} #{year2}"),
    I18n.t('reports.collections_threshold.title3', sort: ordertext)])
  title_excel = format_report_title_excel([
    I18n.t('reports.collections_threshold.title', amount: 
      amount),
    I18n.t('reports.collections_threshold.title2', start: "#{Date::MONTHNAMES[month1]} #{year1}", end: "#{Date::MONTHNAMES[month2]} #{year2}"),
    I18n.t('reports.collections_threshold.title3', sort: ordertext)])
  @report_info = {title: title, title_excel: title_excel}

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: I18n.t('reports.collections_threshold.title_excel'),
      template: 'admins/reports/collections_threshold/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.collections_threshold.title_excel'),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment',
      enable_local_file_access: true

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=CollectionsThreshold.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:month) && params.has_key?(:year) && params.has_key?(:year2) && params.has_key?(:month2)  && params.has_key?(:sortby) && params.has_key?(:threshold) 
  end
end

