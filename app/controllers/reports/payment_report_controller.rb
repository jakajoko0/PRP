class Reports::PaymentReportController < ReportController

def index

end


def report
  redirect_to payment_report_path, notice: "Invalid parameters" unless params_valid?
  @start_date = Date.strptime(params[:start_date], I18n.translate('date.formats.default'))
  @end_date = Date.strptime(params[:end_date], I18n.translate('date.formats.default'))
  target_start = @start_date-1.day
  target_start = target_start.end_of_day
  target_end = @end_date.end_of_day
  
    
  bank_payments = BankPayment.for_franchise_date_range(current_user.franchise_id, target_start, target_end)
  card_payments = CardPayment.for_franchise_date_range(current_user.franchise_id, target_start, target_end)
  check_payments = CheckPayment.for_franchise_date_range(current_user.franchise_id, target_start, target_end)
  
  sum_ach = bank_payments.sum(:amount)
  sum_check = check_payments.sum(:amount)
  sum_card = card_payments.sum(:amount)
  @sums = [sum_ach, sum_card, sum_check]
  @payment_types = [bank_payments, card_payments, check_payments ]
  title = format_report_title([
    I18n.t('reports.franchise_payments.title', start: 
      (I18n.l @start_date), end: (I18n.l @end_date))])
  title_excel = format_report_title_excel([
    I18n.t('reports.franchise_payments.title_excel', start: 
      (I18n.l @start_date), end: (I18n.l @end_date))])
  @report_info = {title: title, title_excel: title_excel, 
                  start_date: target_start, end_date: target_end}

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "Payments",
      template: 'reports/payment_report/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.franchise_payments.title_excel', start: 
      (I18n.l @start_date), end: (I18n.l @end_date)),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=Payments.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:start_date) && params.has_key?(:end_date)
  end
end

