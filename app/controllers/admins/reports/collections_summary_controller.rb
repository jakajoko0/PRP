class Admins::Reports::CollectionsSummaryController < ReportController

def index

end

def report
  return redirect_to admins_collections_summary_path, notice: "Invalid parameters" unless params_valid?
  @result = [] 
  start_date = Date.strptime(params[:start_date], I18n.translate('date.formats.default'))
  end_date = Date.strptime(params[:end_date], I18n.translate('date.formats.default'))
  sortby = params[:sortby].to_i
  consolidate = params[:consolidation].to_i
  tot_coll = 0
  consol = consolidate == 1 ? "Yes" : "No"
  consol_list = FranchiseConsolidation.all_franchises 
  rems = RemittancesQuery.new.colletions_summary_for_date_range(start_date, end_date, sortby,consolidate,consol_list)
  
  if consolidate == 1 
    case sortby
    when 1
      rems = rems.order(:lastname, :firstname)
    when 2
      rems = rems.order(:state, :lastname, :firstname)
    when 3
      rems = rems.order(:reg_group, :region, :lastname, :firstname)
    end
  end  

  case sortby
  #Sort by Franchise
  when 1
    sort_title = "Franchise"
    if rems.length > 0 
      rems.each do |f|
        tot_coll += f.collections
        @result << f
      end
    end
      
  #Sort by State
  when 2
    sort_title = "State"
    if rems.length > 0
      curState = rems[0].state 
      totState = 0.00;
      rems.each do |f|
        #If we process a new state, we add the total first
        if curState != f.state
          @result << {:region => f.region, :state => curState , :firstname => 'Total for', :lastname => curState, :id => 0, :collections => totState, :row_type => 1} 
          totState = 0.00
        end
        @result << f
        curState = f.state 
        totState += f.collections
        tot_coll += f.collections
      end

      @result << {:region => '0', :state => curState , :firstname => 'Total for', :lastname => curState, :id => 0, :collections => totState, :row_type => 1} 
    end

  when 3
    sort_title = "Region"
    if rems.length > 0
      curReg = rems[0].reg_group
      totReg = 0.00;
      rems.each do |f|
        #If we process a new state, we add the total first
        if curReg != f.reg_group
          @result << {:region => '0', :state => '' , :firstname => 'Total for', :lastname => curReg==0 ? 'Home Office' : 'PBS West', :id => 0, :collections => totReg, :row_type => 1} 
          totReg = 0.00
        end

        @result << f
        curReg = f.reg_group 
        totReg += f.collections
        tot_coll += f.collections
      end
      @result << {:region => '0', :state => '' , :firstname => 'Total for', :lastname => curReg==0 ? 'Home Office' : 'PBS West', :id => 0, :collections => totReg, :row_type => 1} 
    end
  end   

 
  title = format_report_title([
    I18n.t('reports.collections_summary.title', sort: sort_title),
    I18n.t('reports.collections_summary.title2', 
      start_date: (I18n.l start_date), end_date: (I18n.l end_date)),
    I18n.t('reports.collections_summary.title3', cons: consol )])

  title_excel = format_report_title_excel([
    I18n.t('reports.collections_summary.title', sort: sort_title),
    I18n.t('reports.collections_summary.title2', 
      start_date: (I18n.l start_date), end_date: (I18n.l end_date)),
    I18n.t('reports.collections_summary.title3', cons: consol )])
  @report_info = {title: title, title_excel: title_excel, tot_collect: tot_coll }

  respond_to do |format|
    format.html
    
    format.pdf do 
      render pdf: "Collections Summary",
      template: 'admins/reports/collections_summary/report_pdf.html.erb',
      layout: 'pdf_report' ,
      page_size: 'Letter',
      title: I18n.t('reports.collections_summary.title_excel'),
      orientation: "portrait",
      print_media_type: true,
      disposition:'attachment',
      enable_local_file_access: true

    end
    format.xlsx{response.headers['Content-Disposition'] = "attachment; filename=CollectionsSummary.xlsx"}
  end

end

private 
  def params_valid?
    params.has_key?(:start_date) && params.has_key?(:end_date) && params.has_key?(:sortby) && params.has_key?(:consolidation)
  end
end

