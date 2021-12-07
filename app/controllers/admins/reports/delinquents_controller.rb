class Admins::Reports::DelinquentsController < ReportController

def index

end


def report
  redirect_to admins_delinquent_report, notice: "Invalid parameters" unless params_valid?
  @results = []
  last_name = ""
  from_month = params[:month][:selected_month].to_i
  from_year = params[:year][:selected_year].to_i
  to_month = params[:month2][:selected_month].to_i
  to_year = params[:year2][:selected_year].to_i
  
  start_date = Date.new(from_year,from_month)
  end_date = Date.new(to_year,to_month).end_of_month

  #Grab Franchises
  franchises = Franchise.includes(:accountants)
  .where("inactive = ? and start_date <= ?",0,end_date)
  .order("lastname, firstname, franchise_number")

  franchises.each do |franchise|
    #Grab Franchise Royalties by year and period, between target
    missing_reports = RemittancesQuery.new.royalty_missing_list(franchise,from_year, from_month, to_year, to_month, start_date, end_date)
    
    if missing_reports.size > 0
      missing_reports.each do |report|
        tmpname = franchise.number_and_name
        if tmpname != last_name
          name_to_insert = tmpname
        else
          name_to_insert = " "
        end
        @results << {franchise: franchise.franchise_number , year: report[1], month: report[2], name: name_to_insert}      
        last_name = franchise.number_and_name
      end  
    end
  end
    

  title = format_report_title([ I18n.t('reports.delinquents.title'),
    I18n.t('reports.delinquents.title2',
      month1: Date::MONTHNAMES[from_month],
      year1: from_year.to_s,
      month2: Date::MONTHNAMES[to_month],
      year2: to_year.to_s  )])
  title_excel = format_report_title_excel([ I18n.t('reports.delinquents.title'),
    I18n.t('reports.delinquents.title2',
      month1: Date::MONTHNAMES[from_month],
      year1: from_year.to_s,
      month2: Date::MONTHNAMES[to_month],
      year2: to_year.to_s  )])
  @report_info = {title: title, title_excel: title_excel }


  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "DelinquentReport",
      template: 'admins/reports/delinquents/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.delinquents.index_title'),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=DelinquentReport.xlsx"}
  end

end

private 
  def params_valid?
     params.has_key?(:month) && params.has_key?(:year) &&
    params.has_key?(:month2) && params.has_key?(:year2)
  end
end

