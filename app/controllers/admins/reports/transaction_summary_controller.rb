class Admins::Reports::TransactionSummaryController < ReportController

def index

end


def report
  redirect_to admins_transaction_summary, notice: "Invalid parameters" unless params_valid?
  if params[:franchise].blank?
    fr = -1
  else
    fr = params[:franchise].to_i
  end
  @start_date = Date.strptime(params[:start_date], I18n.translate('date.formats.default'))
  @end_date = Date.strptime(params[:end_date], I18n.translate('date.formats.default'))
  
  target_start = @start_date.beginning_of_day
  target_end = @end_date.end_of_day
     
  @transact = PrpTransactionsQuery.new.trans_code_summary(target_start, target_end, fr )
  

  if fr == -1 
    frans = "All Franchises"
  else
    frans = Franchise.number_and_name(fr)
  end
  
  title = format_report_title([
    I18n.t('reports.trans_summary.title', start: 
      (I18n.l @start_date), end: (I18n.l @end_date)),
    frans])
  title_excel = format_report_title_excel([
    I18n.t('reports.trans_summary.title', start: 
      (I18n.l @start_date), end: (I18n.l @end_date)),
          frans])
  @report_info = {title: title, title_excel: title_excel }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "Transaction Summary",
      template: 'admins/reports/transaction_summary/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.trans_summary.index_title'),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=Trans Summary.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:start_date) && params.has_key?(:end_date)
  end
end

