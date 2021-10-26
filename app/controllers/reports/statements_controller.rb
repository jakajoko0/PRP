class Reports::StatementsController < ReportController

def index

end

def update_date
  render plain: (I18n.l Date.today.last_year.beginning_of_year).to_json
end

def report
  redirect_to statement_path, notice: "Invalid parameters" unless params_valid?
  @start_date = Date.strptime(params[:start_date], I18n.translate('date.formats.default'))
  @end_date = Date.strptime(params[:end_date], I18n.translate('date.formats.default'))
  target_start = @start_date-1.day
  target_start = target_start.end_of_day
  target_end = @end_date.end_of_day
  
  
  @opening_balance = StatementsQuery.new.balance_on(current_user.franchise_id, target_start)
  @activity = StatementsQuery.new.statement_activity(current_user.franchise_id,@start_date, @end_date )
  @closing_balance = StatementsQuery.new.balance_on(current_user.franchise_id, target_end)
  title = format_report_title([
    I18n.t('reports.franchise_statement.title', start: 
      (I18n.l @start_date), end: (I18n.l @end_date)),
    I18n.t('reports.franchise_statement.title2', report_date: (I18n.l Date.today))])
  title_excel = format_report_title_excel([
    I18n.t('reports.statement.title', start: 
      (I18n.l @start_date), end: (I18n.l @end_date)),
          
    I18n.t('reports.statement.title2', report_date: (I18n.l Date.today))])
  @report_info = {title: title, title_excel: title_excel }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "Statement",
      template: 'reports/statements/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.franchise_statement.title_excel'),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=Statement.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:start_date) && params.has_key?(:end_date)
  end
end

