class ChartsController < ApplicationController

  def all_royalties_by_month
    if params[:target_year]
      this_year = params[:target_year].to_i 
    else
      this_year = Date.today.year
    end
    last_year = this_year - 1
    years = [this_year,last_year]
    colors = []
    colors[this_year] = 
    colors[last_year] = 
    series = years.map {|year|
      {name: year.to_s , data: (1..12).map {|month| [month,rand(250000..680000).to_f]}}
    }
      
    render json: series

   end

end