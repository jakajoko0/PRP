class Admins::Reports::FranchiseListController < ApplicationController

def index

end

def report
  redirect_to admins_franchise_list_path unless params.has_key?(:inactives) && params.has_key?(:sortby)
  include_inactives = params[:inactives].to_i
  sortby = params[:sortby].to_i

  @franchises = Franchise.report_franchise_list(sortby,include_inactives)

  sortby_text = "Sorted by: " + ( sortby == 1 ? "Franchise Number" : "Last Name")
  include_text = include_inactives == 1 ? "Including Inactives" : ""
  title = format_report_title("Franchise List",sortby_text,include_text)
  @report_info = {title: title }

  respond_to do |format|
    format.html
    format.pdf do 
      render pdf: "FranchiseList",
      template: 'admins/reports/franchise_list/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: "Franchise List",
      orientation: "landscape",
      print_media_type: true,
      disposition:'attachment'

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename='FranchiseList.xlsx'"}
  end

end

private
def format_report_title(*title_text)
    html = ""
    title_text.each do |text|
      html = html+text+"<br>" if !text.blank?
    end
    html.html_safe
  end

end