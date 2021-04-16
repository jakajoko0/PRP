class Admins::Reports::FinancialAggregationController < ReportController

def index
end

def report
  redirect_to admins_financial_aggregation_path, notice: "Invalid parameters" unless params_valid?
  sortby = params[:sortby]
  yr = params[:year]
  franchise = params[:franchise].blank? ? -1 : params[:franchise].to_i

  year = yr[:year].to_i
  
  @records = FinancialsQuery.new.aggregation_report(franchise, year,sortby)
  sortby_text = sortby_title(sortby)
  
  title = format_report_title([I18n.t('reports.financial_aggregation.title'),
                               I18n.t('reports.financial_aggregation.title_year', yr: year),
                               (franchise == -1 ? I18n.t('reports.financial_aggregation.title_all') : Franchise.number_and_name(franchise)),
                              sortby_text])
  title_excel = format_report_title_excel([I18n.t('reports.financial_aggregation.title'),
                               I18n.t('reports.financial_aggregation.title_year', yr: year),
                               (franchise == -1 ? I18n.t('reports.financial_aggregation.title_all') : Franchise.number_and_name(franchise)),
                              sortby_text])
  @report_info = {title: title, title_excel: title_excel, franchise: franchise }

  respond_to do |format|
    format.html
    format.pdf do 
      render pdf: "FinancialAggregation",
      template: 'admins/reports/financial_aggregation/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.financial_aggregation.title'),
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename='FinancialAggregation.xlsx'"}
  end

end

private 
  def params_valid?
    params.has_key?(:sortby) && params.has_key?(:franchise) && params.has_key?(:year)
  end
end

