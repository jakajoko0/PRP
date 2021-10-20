class Admins::Reports::FranchiseAdvancedRebateController < ReportController

def report
  @franchises = FranchisesQuery.new.using_advanced_rebates
  title = format_report_title([I18n.t('reports.franchise_advanced_rebate.title')])
  title_excel = format_report_title_excel([I18n.t('reports.franchise_advanced_rebate.title')])
  @report_info = {title: title, title_excel: title_excel }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "FranchiseAdvancedRebate",
      template: 'admins/reports/franchise_advanced_rebate/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.franchise_advanced_rebate.title'),
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=FranchiseAdvancedRebate.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:month) && params.has_key?(:year) &&
    params.has_key?(:month2) && params.has_key?(:year2)
  end

end

