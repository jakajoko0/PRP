class Admins::Reports::PaymentMethodsController < ReportController

def index

end

def report
  redirect_to admins_payment_methods_missing_path, notice: "Invalid parameters" unless params_valid?
  include_inactives = params[:inactives].to_i
  sortby = params[:sortby]
  
  credit_cards = CreditCardsQuery.new.credit_card_list_sorted(include_inactives,sortby)

  bank_accounts = BankAccountsQuery.new.bank_account_list_sorted(include_inactives,sortby)
  
  

  @franchises = Franchise.from("((#{bank_accounts.to_sql}) UNION (#{credit_cards.to_sql})) AS franchises").order(sortby+",type ASC")

  sortby_text = sortby_title(sortby)
  title = format_report_title([
    I18n.t('reports.payment_method.title'),
                              sortby_text])
  title_excel = format_report_title_excel([I18n.t('reports.payment_method.title_excel'),
                              sortby_text])
  @report_info = {title: title, title_excel: title_excel }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "PaymentMethods",
      template: 'admins/reports/payment_methods/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.payment_methods.title_excel'),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=PaymentMethods.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:inactives) && params.has_key?(:sortby)
  end

end

