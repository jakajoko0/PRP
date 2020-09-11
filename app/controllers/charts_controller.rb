class ChartsController < ApplicationController

  def all_royalties_by_month
    if params[:target_year]
      this_year = params[:target_year].to_i 
    else
      this_year = Date.today.year
    end
    last_year = this_year - 1
    years = [this_year,last_year]
    series = years.map {|year|
      {name: year.to_s , data: (1..12).map {|month| [month,rand(250000..680000).to_f]}}
    }
      
    render json: series

  end

  def revenue_by_state
    target_year = params[:target_year].to_i || Date.today.year

    target_month = params[:target_month].to_i || Date.today.month
    
    series = [["US-GA",5000],
              ["US-AL",3500],
              ["US-SC",45000],
              ["US-MA",13500],
              ["US-FL",18500],
              ["US-TX",22500],
              ["US-CA",33500],
              ["US-NC",65300]]

    render json: series
  end

   def collections_by_category
    target_year = params[:target_year].to_i || Date.today.year
    target_month = params[:target_month].to_i || Date.today.month

    series = [["Accounting",50000],
              ["Tax Prep",15000],
              ["Consultation",5000],
              ["Backwork",750],
              ["Setup",2500],
              ["Other1",0],
              ["Other2",0],
              ["Excluded",0]]

    render json: series
   end

end