class PublicController < ApplicationController
  def main
  end

  def userpage
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
