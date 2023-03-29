class Admins::Reports::TransactionDetailController < ReportController

  def index

  end


  def report
    redirect_to admins_transaction_detail, notice: "Invalid parameters" unless params_valid?
    redirect_to admins_transaction_detail, notice: "Invalid Dates. Check Date format" unless dates_valid?
    
    if params[:franchise].blank?
      fr = -1
    else
      fr = params[:franchise].to_i
    end
    @start_date = Date.strptime(params[:start_date], I18n.translate('date.formats.default'))
    @end_date = Date.strptime(params[:end_date], I18n.translate('date.formats.default'))
    @code = params[:trans_code]
    
    target_start = @start_date.beginning_of_day
    target_end = @end_date.end_of_day
    
    @transact = PrpTransactionsQuery.new.trans_code_detail(target_start, target_end, fr, @code )
    
    total = @transact.reduce(0) {|sum,t| sum += t.amount}

    if fr == -1 
      frans = "All Franchises"
    else
      frans = Franchise.number_and_name(fr)
    end
    
    title = format_report_title([
      I18n.t('reports.trans_detail.title', start: 
        (I18n.l @start_date), end: (I18n.l @end_date)),
      I18n.t('reports.trans_detail.title2', code: @code, desc: TransactionCode.description_from_code(@code)),
      frans])
    title_excel = format_report_title_excel([
      I18n.t('reports.trans_detail.title', start: 
        (I18n.l @start_date), end: (I18n.l @end_date)),
      I18n.t('reports.trans_detail.title2', code: @code, desc: TransactionCode.description_from_code(@code)),
            frans])
    @report_info = {title: title, title_excel: title_excel, fr: fr, total: total }

    respond_to do |format|
      format.html
      
      format.pdf do 
        render pdf: "Transaction Detail",
        template: 'admins/reports/transaction_detail/report_pdf.html.erb',
        layout: 'pdf_report' ,
        page_size: 'Letter',
        title: I18n.t('reports.trans_detail.index_title'),
        orientation: "portrait",
        print_media_type: true,
        disposition:'attachment'

      end
      format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=Trans Detail.xlsx"}
    end

  end

  private 
  
  def params_valid?
    params.has_key?(:trans_code) && params.has_key?(:start_date) && params.has_key?(:end_date)
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

