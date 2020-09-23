class Admins::Reports::FranchiseExpirationController < ReportController

def index

end

def report
  redirect_to admins_franchise_expiration_path, notice: "invalid params" unless params_valid?
  from_month = params[:month][:selected_month].to_i
  from_year = params[:year][:selected_year].to_i
  to_month = params[:month2][:selected_month].to_i
  to_year = params[:year2][:selected_year].to_i
  start_date = Date.new(from_year,from_month)
  end_date = Date.new(to_year,to_month)

  @franchises = FranchisesQuery.new.franchise_expiring(start_date, end_date)
  range_text = "#{I18n.t('date.month_names')[from_month]} #{from_year.to_s} #{I18n.t('reports.general.thru')} #{I18n.t('date.month_names')[to_month]} #{to_year.to_s}"
  title = format_report_title([I18n.t('reports.franchise_expiration.title'),
                              range_text])
  title_excel = format_report_title_excel([I18n.t('reports.franchise_expiration.title'),
                              range_text])
  @report_info = {title: title, title_excel: title_excel }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "FranchiseExpiring",
      template: 'admins/reports/franchise_expiration/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.franchise_expiration.title'),
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename='FranchiseExpiration.xlsx'"}
  end

end

private 
  def params_valid?
    params.has_key?(:month) && params.has_key?(:year) &&
    params.has_key?(:month2) && params.has_key?(:year2)
  end

end

