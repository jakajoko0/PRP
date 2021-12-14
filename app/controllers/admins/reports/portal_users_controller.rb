class Admins::Reports::PortalUsersController < ReportController
helper_method :sort_column, :sort_direction
def report
  @signed_users = User.includes(:franchise).order(sort_column + " " + sort_direction)
  distinct_franchises = User.select('franchise_id').distinct
  
  title = format_report_title([I18n.t('reports.portal_users.title')])
  title_excel = format_report_title_excel([I18n.t('reports.portal_users.title_excel')])

  @report_info = {title: title, title_excel: title_excel,total_users: @signed_users.length, total_franchises: distinct_franchises.length}

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "PortalUsers",
      template: 'admins/reports/portal_users/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.portal_users.title'),
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=PortalUsers.xlsx"}
  end

end

private 
  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end

