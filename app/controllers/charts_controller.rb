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
      {name: year.to_s , 
       data: RemittancesQuery.new.monthly_royalties_for_year(year)}
      }
      
    render json: series
  end

  def collections_by_month
    
    this_year = if params[:target_year]
                  params[:target_year].to_i 
                else
                  Date.today.year
                end
      
    last_year = this_year - 1
    years = []
    years << this_year
    years << last_year

    series = years.map { |year|
      { name: year.to_s,
        data: (1..12).map { |month| [month, RemittancesQuery.new.total_collections_for_graph(current_user.franchise_id, year, month).to_f] }
      }
    }

    render json: series
  end

  def revenue_by_state
    target_year = params[:target_year].to_i || Date.today.year

    target_month = params[:target_month].to_i || Date.today.month
    
    series = RemittancesQuery.new.total_royalties_by_state(target_year, target_month)

    render json: series
  end

   def collections_by_category
    target_year = params[:target_year].to_i || Date.today.year
    target_month = params[:target_month].to_i || Date.today.month

    series = RemittancesQuery.new.total_collections_by_category(target_year, target_month)
    
    render json: series
   end

end