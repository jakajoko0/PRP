class Admins::Reports::FranchiseListController < ReportController

def index

end

def report
  redirect_to admins_franchise_list_path unless params.has_key?(:inactives) && params.has_key?(:sortby)
  include_inactives = params[:inactives].to_i
  sortby = params[:sortby]

  @franchises = FranchisesQuery.new.franchise_list_sorted(include_inactives,sortby)
  sortby_text = sortby_title(sortby)
  include_text = include_title(include_inactives)
  title = format_report_title(I18n.t('reports.franchise_list.title'),
                              sortby_text,
                              include_text)
  @report_info = {title: title }

  respond_to do |format|
    format.html
    format.pdf do 
      render pdf: "FranchiseList",
      template: 'admins/reports/franchise_list/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.franchise_list.title'),
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename='FranchiseList.xlsx'"}
  end

end
end

