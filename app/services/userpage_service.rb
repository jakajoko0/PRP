module UserpageService
  class << self 
    #========================================================
    #COLLECTIONS
    #========================================================
    def get_collections_for_current_period(year,month,franchise)
      RemittancesQuery.new.franchise_collections_for_month(year,month,franchise)
    end

    def get_collections_for_last_period(year,month,franchise)
      if month == 1
        month = 12
        year = year -1
      else
        month = month -1
      end
      RemittancesQuery.new.franchise_collections_for_month(year,month,franchise)
    end

    def get_collections_for_last_year(year,month,franchise)
      year = year -1
      RemittancesQuery.new.franchise_collections_for_month(year,month,franchise)
    end
  

    #========================================================
    #AVERAGE COLLECTIONS
    #========================================================
    def get_average_collections_for_period(year,month)
      RemittancesQuery.new.total_average_collections_for_month(year,month)
    end

     def get_average_collections_for_last_period(year,month)
      if month == 1
        month = 12
        year = year -1
      else
        month = month -1
      end
      RemittancesQuery.new.total_average_collections_for_month(year,month)
    end

    def get_average_collections_for_last_year(year,month)
      year = year -1
      RemittancesQuery.new.total_average_collections_for_month(year,month)
    end

    #========================================================
    #MONTHLY RANKING COLLECTIONS
    #========================================================
    def get_monthly_ranking(year,month,franchise)
      FranchisesQuery.new.get_monthly_ranking(franchise,year,month)
    end

    def get_prior_month_ranking(year,month,franchise)
      if month == 1
        month = 12
        year = year -1
      else
        month = month -1
      end
      FranchisesQuery.new.get_monthly_ranking(franchise,year,month)
    end

    def get_prior_year_ranking(year,month,franchise)
      year = year -1 
      FranchisesQuery.new.get_monthly_ranking(franchise,year,month)
    end

    def get_ytd_ranking(year,month,franchise)
      FranchisesQuery.new.get_ytd_ranking(franchise,year,month)
    end

    def get_ytd_ranking_prior_period(year,month,franchise)
      if month == 1
        month = 12
        year = year -1
      else
        month = month -1
      end
      FranchisesQuery.new.get_ytd_ranking(franchise,year,month)
    end

    def get_ytd_ranking_prior_year(year,month,franchise)
      year = year - 1
      FranchisesQuery.new.get_ytd_ranking(franchise,year,month)
    end

   

    #========================================================
    #YTD COLLECTIONS
    #========================================================
    def get_ytd_collection_for_period(year,month,franchise)
      RemittancesQuery.new.franchise_ytd_collections(year,month,franchise)
    end

    def get_ytd_collection_prior_period(year,month,franchise)
      if month == 1
        month = 12
        year = year -1
      else
        month = month -1
      end

      RemittancesQuery.new.franchise_ytd_collections(year,month,franchise)

    end

    def get_ytd_collection_prior_year(year,month,franchise)
      year = year - 1
      RemittancesQuery.new.franchise_ytd_collections(year,month,franchise)
    end


    def get_ytd_average_collections(year,month)
      RemittancesQuery.new.ytd_average_collections(year,month)
    end

    def get_ytd_average_prior_period(year,month)
      if month == 1
        month = 12
        year = year -1
      else
        month = month -1
      end
      RemittancesQuery.new.ytd_average_collections(year,month)
    end


    def get_ytd_average_prior_year(year,month)
      year = year - 1
      RemittancesQuery.new.ytd_average_collections(year,month)
    end

    def get_latest_roy_trans(franchise_id)
      puts "FRANCHISE ID BEFORE CALL #{franchise_id}"
      PrpTransactionsQuery.new.latest_roy_trans(franchise_id)
    end

    def get_latest_inv_trans(franchise_id)
      PrpTransactionsQuery.new.latest_inv_trans(franchise_id)
    end



  end
end