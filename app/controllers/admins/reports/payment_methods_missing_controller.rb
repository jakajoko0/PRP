class Admins::Reports::PaymentMethodsMissingController < ReportController

def index

end

def report
  redirect_to admins_payment_methods_path, notice: "Invalid parameters" unless params_valid?
  include_inactives = params[:inactives].to_i
  sortby = params[:sortby]
  
  no_cards = CreditCardsQuery.new.no_credit_cards_on_file(include_inactives,sortby)

  no_bank_accounts = BankAccountsQuery.new.no_bank_account_on_file(include_inactives,sortby)
  

  @franchises = no_cards.merge(no_bank_accounts)

  sortby_text = sortby_title(sortby)
  title = format_report_title([
    I18n.t('reports.payment_method_missing.title'),
                              sortby_text])
  title_excel = format_report_title_excel([I18n.t('reports.payment_method_missing.title_excel'),
                              sortby_text])
  @report_info = {title: title, title_excel: title_excel }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "PaymentMethodsMissing",
      template: 'admins/reports/payment_methods_missing/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'A4',
      title: I18n.t('reports.payment_method_missing.title'),
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment',
      margin: {top: 10}

      


    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=PaymentMethodsMissing.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:inactives) && params.has_key?(:sortby)
  end

end

