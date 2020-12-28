class Admins::Reports::FinancialCountAndAveragesController < ReportController

def index
end

def report
  redirect_to admins_financial_count_averages_path, notice: "Invalid parameters" unless params_valid?
  sortby = params[:sortby]
  yr = params[:year]
  franchise = params[:franchise].blank? ? -1 : params[:franchise].to_i

  year = yr[:year].to_i
  
  @average_counts = FinancialsQuery.new.count_averages_report(franchise, year,sortby)
  totals = @average_counts.pop
  total_count = @average_counts.size

  totals[:average_monthly_fees] = (totals[:average_monthly_fees] / total_count)
  totals[:average_quarterly_fees] = (totals[:average_quarterly_fees] / total_count)
  

  sortby_text = sortby_title(sortby)
  
  title = format_report_title([I18n.t('reports.financial_count_averages.title'),
                               I18n.t('reports.financial_count_averages.title_year', yr: year),
                               (franchise == -1 ? I18n.t('reports.financial_count_averages.title_all') : Franchise.number_and_name(franchise)),
                              sortby_text])
  title_excel = format_report_title_excel([I18n.t('reports.financial_count_averages.title'),
                               I18n.t('reports.financial_count_averages.title_year', yr: year),
                               (franchise == -1 ? I18n.t('reports.financial_count_averages.title_all') : Franchise.number_and_name(franchise)),
                              sortby_text])
  @report_info = {title: title, title_excel: title_excel,
                  totals: totals, franchise: franchise }

  respond_to do |format|
    format.html
    format.pdf do 
      render pdf: "FinancialCountAverages",
      template: 'admins/reports/financial_count_and_averages/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.financial_count_averages.title'),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename='FinancialCountAverages.xlsx'"}
  end

end

private 
  def params_valid?
    params.has_key?(:sortby) && params.has_key?(:franchise) && params.has_key?(:year)
  end
end

