class Admins::Reports::StatementsController < ReportController

  def index
  end

  def update_date
    render plain: (I18n.l Date.today.last_year.beginning_of_year).to_json
  end

  def report
    redirect_to admins_statements, notice: "Invalid parameters" unless params_valid?
    redirect_to admins_statements, notice: "Invalid Dates. Check Date format" unless dates_valid?
    
    @franchise_id = params[:franchise].to_i
    @start_date = Date.strptime(params[:start_date], I18n.translate('date.formats.default'))
    @end_date = Date.strptime(params[:end_date], I18n.translate('date.formats.default'))
    target_start = @start_date-1.day
    target_start = target_start
    target_end = @end_date


    @opening_balance = StatementsQuery.new.balance_on(@franchise_id, target_start)
   
    @activity = StatementsQuery.new.statement_activity(@franchise_id,@start_date.to_time, @end_date.to_time )

    @closing_balance = StatementsQuery.new.balance_on(@franchise_id, target_end)
    title = format_report_title([
      I18n.t('reports.statement.title', start: 
        (I18n.l @start_date), end: (I18n.l @end_date)),
      Franchise.number_and_name(@franchise_id),
      I18n.t('reports.statement.title2', report_date: (I18n.l Date.today))])
    title_excel = format_report_title_excel([
      I18n.t('reports.statement.title', start: 
        (I18n.l @start_date), end: (I18n.l @end_date)),
            Franchise.number_and_name(@franchise_id),
      I18n.t('reports.statement.title2', report_date: (I18n.l Date.today))])
    @report_info = {title: title, title_excel: title_excel }

    respond_to do |format|
      format.html
      
      format.pdf do 
        render pdf: "Statement",
        template: 'admins/reports/statements/report_pdf.html.erb',
        layout: 'pdf_report' ,
        page_size: 'Letter',
        title: I18n.t('reports.statement.title_excel'),
        orientation: "portrait",
        print_media_type: true,
        disposition:'attachment'

      end
      format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=Statement #{Franchise.number_and_name(@franchise_id)}.xlsx"}
    end

  end

  private 
  
  def params_valid?
    params.has_key?(:franchise) && params.has_key?(:start_date) && params.has_key?(:end_date)
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

