class Admins::Reports::InactiveFranchiseListController < ReportController

def index

end

def report
  redirect_to admins_inactive_franchise_list_path unless params.has_key?(:sortby)
  sortby = params[:sortby]

  @franchises = FranchisesQuery.new.inactive_franchise_list_sorted(sortby)
  sortby_text = sortby_title(sortby)
  title = format_report_title([I18n.t('reports.inactive_franchise_list.title'),
                              sortby_text])
  title_excel = format_report_title_excel([I18n.t('reports.inactive_franchise_list.title'),
                              sortby_text])
  @report_info = {title: title, title_excel: title_excel }

  respond_to do |format|
    format.html
    format.pdf do 
      render pdf: "InactiveFranchiseList",
      template: 'admins/reports/inactive_franchise_list/report_pdf.html.erb',
      layout: 'pdf_report', 
      page_size: 'Letter',
      title: I18n.t('reports.inactive_franchise_list.title'),
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment'
      

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=InactiveFranchiseList.xlsx"}
  end

end
end

