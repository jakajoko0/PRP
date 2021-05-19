class PublicController < ApplicationController
  def main
  end

  def userpage
    #Compute the proper year and month
    if params[:target_month] && params[:target_year]
      @year = params[:target_year].to_i
      @month = params[:target_month].to_i
    else
      current_day = Date.today-1.month
      @year = current_day.year
      @month = current_day.month
    end

    #Get Franchise current collections / Prior Month / Prior Year
    @current_collections = UserpageService.get_collections_for_current_period(@year,@month,current_user.franchise_id)
    prior_collections = UserpageService.get_collections_for_last_period(@year,@month,current_user.franchise_id)
    last_year_collections = UserpageService.get_collections_for_last_year(@year,@month,current_user.franchise_id)

    #Compute the differences
    @prior_coll_diff = @current_collections - prior_collections
    @last_year_coll_diff = @current_collections - last_year_collections

    #Compute the proper arrow class
    @prior_coll_class = @prior_coll_diff >= 0.00  ? "green" : "red"
    @last_year_coll_class = @last_year_coll_diff >= 0.00 ? "green" : "red"

    #Get the total average collections / Prior Month / Prior Year
    @average_collections = UserpageService.get_average_collections_for_period(@year,@month)
    prior_avg_collections = UserpageService.get_average_collections_for_last_period(@year,@month)
    last_year_avg_collections = UserpageService.get_average_collections_for_last_year(@year,@month)

    #Compute the differences
    @prior_avg_coll_diff = @average_collections - prior_avg_collections
    @last_year_avg_coll_diff = @average_collections - last_year_avg_collections

    #Compute the proper arrow class
    @prior_avg_class = @prior_avg_coll_diff >= 0.00  ? "green" : "red"
    @last_year_coll_class = @last_year_avg_coll_diff >= 0.00 ? "green" : "red"
    
    @current_ranking = UserpageService.get_monthly_ranking(@year,@month,current_user.franchise_id)
    @prior_ranking = UserpageService.get_prior_month_ranking(@year,@month,current_user.franchise_id)
    @last_year_ranking = UserpageService.get_prior_year_ranking(@year,@month,current_user.franchise_id)

    #Get Franchise ytd collections / Prior Month / Prior Year
    @ytd_collections = UserpageService.get_ytd_collection_for_period(@year, @month, current_user.franchise_id)
    prior_ytd = UserpageService.get_ytd_collection_prior_period(@year, @month, current_user.franchise_id)
    last_year_ytd = UserpageService.get_ytd_collection_prior_year(@year, @month, current_user.franchise_id)

    #Compute the differences
    @prior_ytd_diff = @ytd_collections - prior_ytd
    @last_year_ytd_diff = @ytd_collections - last_year_ytd

    #Compute the proper arrow class
    @prior_ytd_class = @prior_ytd_diff >= 0.00  ? "green" : "red"
    @last_year_ytd_class = @last_year_ytd_diff >= 0.00 ? "green" : "red"

    #Get Franchise ytd collections / Prior Month / Prior Year
    @ytd_avg_collections = UserpageService.get_ytd_average_collections(@year, @month)
    prior_avg_ytd = UserpageService.get_ytd_average_prior_period(@year, @month)
    last_year_avg_ytd = UserpageService.get_ytd_average_prior_year(@year, @month)

    #Compute the differences
    @prior_ytd_avg_diff = @ytd_avg_collections - prior_avg_ytd
    @last_year_ytd_avg_diff = @ytd_avg_collections - last_year_avg_ytd

    #Compute the proper arrow class
    @prior_ytd_avg_class = @prior_ytd_avg_diff >= 0.00  ? "green" : "red"
    @last_year_ytd_avg_class = @last_year_ytd_avg_diff >= 0.00 ? "green" : "red"

    @current_ytd_ranking = UserpageService.get_ytd_ranking(@year,@month,current_user.franchise_id)
    @prior_ytd_ranking = UserpageService.get_ytd_ranking_prior_period(@year,@month,current_user.franchise_id)
    @last_year_ytd_ranking = UserpageService.get_ytd_ranking_prior_year(@year,@month,current_user.franchise_id)



  	@expiring_cards = CreditCard.expiring_cards(current_user.franchise)
    @expired_cards = CreditCard.expired_cards(current_user.franchise)
    @invalid_payment_token = WebsitePreference.valid_payment_token?(current_user.franchise.id)
  end

  def adminpage
    if params[:target_month] && params[:target_year]
      @year = params[:target_year].to_i
      @month = params[:target_month].to_i
    else
  	  current_day = Date.today-1.month
  	  @year = current_day.year
  	  @month = current_day.month
    end

    #Section about Collections
    @current_collections = AdminpageService.get_collections_for_current_period(@year,@month)
    prior_collections = AdminpageService.get_collections_for_last_period(@year,@month)
    last_year_collections = AdminpageService.get_collections_for_last_year(@year,@month)

    @prior_coll_diff = @current_collections - prior_collections
    @last_year_coll_diff = @current_collections - last_year_collections

    @prior_coll_class = @prior_coll_diff >= 0.00  ? "green" : "red"
    @last_year_coll_class = @last_year_coll_diff >= 0.00 ? "green" : "red"


    #Section about Royalties
    @current_royalties = AdminpageService.get_royalties_for_current_period(@year,@month)
    prior_royalties = AdminpageService.get_royalties_for_last_period(@year,@month)
    last_year_royalties = AdminpageService.get_royalties_for_last_year(@year,@month)

    @prior_roy_diff = @current_royalties - prior_royalties 
    @last_year_roy_diff = @current_royalties - last_year_royalties 

    @prior_roy_class = @prior_roy_diff >= 0.00 ? "green" : "red"
    @last_year_roy_class = @last_year_roy_diff >= 0.00 ? "green" : "red"

    #Section about Average Collections
    @average_collections = AdminpageService.get_average_collections_for_period(@year,@month)
    prior_avg_collect = AdminpageService.get_average_collections_for_last_period(@year,@month)
    last_year_avg_collect = AdminpageService.get_average_collections_for_last_year(@year,@month)


    @prior_coll_avg_diff = @average_collections - prior_avg_collect
    @last_year_coll_avg_diff = @average_collections - last_year_avg_collect

    @prior_coll_avg_class = @prior_coll_avg_diff >= 0.00 ? "green" : "red"
    @last_year_coll_avg_class = @last_year_coll_avg_diff >= 0.00 ? "green" : "red"

    #Section about Average Royalties
    @average_royalties = AdminpageService.get_average_royalties_for_period(@year,@month)
    prior_avg_roy = AdminpageService.get_average_royalties_for_last_period(@year,@month)
    last_year_avg_roy = AdminpageService.get_average_royalties_for_last_year(@year,@month)

    @prior_roy_avg_diff = @average_royalties - prior_avg_roy
    @last_year_roy_avg_diff = @average_royalties - last_year_avg_roy

    @prior_roy_avg_class = @prior_roy_avg_diff >= 0.00 ? "green" : "red"
    @last_year_roy_avg_class = @last_year_roy_avg_diff >= 0.00 ? "green" : "red"


  end
end
