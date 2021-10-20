class Admins::Reports::AmountsDueController < ReportController

def index

end


def report
  redirect_to admins_amounts_due, notice: "Invalid parameters" unless params_valid?
  @target_date = Date.strptime(params[:target_date], I18n.translate('date.formats.default'))
  total_due = 0
  @results = []
  
  
  @results = FranchisesQuery.new.amounts_due(@target_date.end_of_day)
  total_due = @results.reduce(0) {|sum,f| sum + f.balance}
  

  title = format_report_title([ I18n.t('reports.amounts_due.title', target_date: 
      (I18n.l @target_date))])
  title_excel = format_report_title_excel([
    I18n.t('reports.amounts_due.title', target_date: 
      (I18n.l @target_date))])
  @report_info = {title: title, title_excel: title_excel, total_due: total_due }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "AmountsDue",
      template: 'admins/reports/amounts_due/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.amounts_due.title_excel'),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=AmountsDue.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:target_date)
  end
end

