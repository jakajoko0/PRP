class Admins::AuditsController < ApplicationController
  def index
  
    @resource = params[:resource] || ""
    @starting = params[:start_date] || ""
    @ending = params[:end_date] || ""
    @actions = params[:operand] || ""
    
    if !@starting.blank? 
      @start_date = Date.strptime(@starting, I18n.translate('date.formats.default'))
      @start_date = @start_date.beginning_of_day
    end

    if !@ending.blank? 
      @end_date = Date.strptime(@ending, I18n.translate('date.formats.default'))
      @end_date = @end_date.end_of_day
    end


    @audits= Audit.includes(:user).from_date(@start_date)
    .to_date(@end_date)
    .for_resource(@resource)
    .for_actions(@actions)
    .order("created_at DESC")
    .paginate(per_page: 20, page: params[:page])
  
  end 
    
  

end


