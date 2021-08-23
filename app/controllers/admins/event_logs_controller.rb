class Admins::EventLogsController < ApplicationController
  def index
  
    @email = params[:email] || ""
    @franchise = params[:franchise] || ""
    @starting = params[:start_date] || ""
    @ending = params[:end_date] || ""
    
    if !@starting.blank? 
      @start_date = Date.strptime(@starting, I18n.translate('date.formats.default'))
    end

    if !@ending.blank? 
      @end_date = Date.strptime(@ending, I18n.translate('date.formats.default'))
    end

    
    @events= EventLog.all.for_user(@email)
    .from_date(@start_date)
    .to_date(@end_date)
    .for_franchise(@franchise)
    .paginate(per_page: 20, page: params[:page])
  
  end 
    
  

end


