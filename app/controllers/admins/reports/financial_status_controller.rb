class Admins::Reports::FinancialStatusController < ReportController

def index

end

def report
  redirect_to admins_financial_status_path, notice: "Invalid parameters" unless params_valid?
  sortby = params[:sortby]
  yr = params[:year]
  status = params[:status].to_i

  case status 
  when 1
    statustext = I18n.t('reports.financial_status.reported')
  when 2
    statustext = I18n.t('reports.financial_status.unreported')
  when 3
    statustext = I18n.t('reports.financial_status.all')
  end

  year = yr[:year].to_i
  
  @financial_status = FinancialsQuery.new.reporting_status(year,status,sortby)
  
  reported = @financial_status.count {|x| x.status == 1}
  unreported = @financial_status.count {|x| x.status == 0}
  total = @financial_status.size

  sortby_text = sortby_title(sortby)
  
  title = format_report_title([I18n.t('reports.financial_status.title'),
                               I18n.t('reports.financial_status.title_year', yr: year),
                               I18n.t('reports.financial_status.title_status', statustext: statustext), 
                              sortby_text])
  title_excel = format_report_title_excel([I18n.t('reports.financial_status.title'),
                               I18n.t('reports.financial_status.title_year', yr: year),
                               I18n.t('reports.financial_status.title_status', statustext: statustext), 
                              sortby_text])
  @report_info = {title: title, title_excel: title_excel,
                  reported: reported, unreported: unreported,
                  total: total, status: status }

  respond_to do |format|
    format.html
    format.pdf do 
      render pdf: "FinancialReportingStatus",
      template: 'admins/reports/financial_status/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.financial_status.title'),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=FinancialReportingStatus.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:sortby) && params.has_key?(:status) && params.has_key?(:year)
  end
end

