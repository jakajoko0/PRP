class Admins::Reports::InsuranceExpirationController < ReportController

def index

end

def report
  redirect_to admins_insurance_expiration_path, notice: "Invalid parameters" unless params_valid?
  target_date = Date.strptime(params[:target_date], I18n.translate('date.formats.default'))
  sortby = params[:sortby]
  
  @insurances = InsurancesQuery.new.insurance_expiring(target_date,sortby)
  sortby_text = sortby_title(sortby)
  title = format_report_title([
    I18n.t('reports.insurance_expiration.title', target_date: I18n.l(target_date)),
                              sortby_text])
  title_excel = format_report_title_excel([I18n.t('reports.insurance_expiration.title', target_date: I18n.l(target_date)),
                              sortby_text])
  @report_info = {title: title, title_excel: title_excel }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "InsuranceExpiring",
      template: 'admins/reports/insurance_expiration/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.insurance_expiration.title_excel'),
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename='FranchiseExpiration.xlsx'"}
  end

end

private 
  def params_valid?
    params.has_key?(:target_date) && params.has_key?(:sortby)
  end

end

