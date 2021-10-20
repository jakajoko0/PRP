class Admins::Reports::InsuranceMissingController < ReportController

def index

end

def report
  redirect_to admins_insurance_missing_path, notice: "Invalid parameters" unless params_valid?
  sortby = params[:sortby]
  
  @franchises = InsurancesQuery.new.insurance_missing(sortby)
  sortby_text = sortby_title(sortby)
  title = format_report_title([
    I18n.t('reports.insurance_missing.title'),
                              sortby_text])
  title_excel = format_report_title_excel([I18n.t('reports.insurance_missing.title'),
                              sortby_text])
  @report_info = {title: title, title_excel: title_excel }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "InsuranceMissing",
      template: 'admins/reports/insurance_missing/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.insurance_missing.title'),
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=InsuranceMissing.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:sortby)
  end

end

