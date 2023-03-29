class Admins::Reports::AuditTrailReportController < ReportController
  def index
  end 

  def report 
    return redirect_to admins_audit_trail_report_path, notice: "Invalid date. Check date format" unless dates_valid?
    @resource = params[:resource]
    @starting = params[:start_date] || ""
    @ending = params[:end_date] || ""
    @actions = params[:operand] || ""
    
    
    if !@starting.blank? 
      @start_date = Date.strptime(@starting, I18n.translate('date.formats.default'))
      @start_date = @start_date.beginning_of_day
    end

    if !@ending.blank? 
      @end_date = Date.strptime(@ending, I18n.translate('date.formats.default'))
      @end_date = @end_date.end_of_day
    end


    @audits= Audit.includes(:user).from_date(@start_date)
    .to_date(@end_date)
    .for_resource(@resource)
    .for_actions(@actions)
    .order("created_at DESC")

    title = format_report_title([
      I18n.t('reports.audit_trail.title', resource: @resource),
      I18n.t('reports.audit_trail.title2', start: (I18n.l @start_date) , end: (I18n.l @end_date)),
      I18n.t('reports.audit_trail.title3', operation: @actions)])

    title_excel = format_report_title_excel([
      I18n.t('reports.audit_trail.title', resource: @resource),
      I18n.t('reports.audit_trail.title2', start: (I18n.l @start_date) , end: (I18n.l @end_date)),
      I18n.t('reports.audit_trail.title3', operation: @actions)])

    @report_info = {title: title, title_excel: title_excel }

    respond_to do |format|
      format.html
    
      format.pdf do 
        render pdf: "AuditTrailReport",
        template: 'admins/reports/audit_trail_report/report_pdf.html.erb',
        layout: 'pdf_report' ,
        page_size: 'Letter',
        title: I18n.t('reports.audit_trail.index_title'),
        orientation: "portrait",
        print_media_type: true,
        disposition:'attachment'
      end
      format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=AuditTrailReport.xlsx"}
    end
  end

  private

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


