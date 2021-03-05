module AdminpageService
  class << self 
    #========================================================
    #COLLECTIONS
    #========================================================
    def get_collections_for_current_period(year,month)
      RemittancesQuery.new.total_collections_for_month(year,month)
    end

    def get_collections_for_last_period(year,month)
      if month == 1
        month = 12
        year = year -1
      else
        month = month -1
      end
      RemittancesQuery.new.total_collections_for_month(year,month)
    end

    def get_collections_for_last_year(year,month)
      year = year -1
      RemittancesQuery.new.total_collections_for_month(year,month)
    end
  
    #========================================================
    #ROYALTIES
    #========================================================
    def get_royalties_for_current_period(year,month)
      RemittancesQuery.new.total_royalties_for_month(year,month)
    end

    def get_royalties_for_last_period(year,month)
      if month == 1
        month = 12
        year = year -1
      else
        month = month -1
      end
      RemittancesQuery.new.total_royalties_for_month(year,month)
    end

    def get_royalties_for_last_year(year,month)
      year = year -1
      RemittancesQuery.new.total_royalties_for_month(year,month)
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
    #AVERAGE ROYALTIES
    #========================================================
    def get_average_royalties_for_period(year,month)
      RemittancesQuery.new.total_average_royalties_for_month(year,month)
    end

    def get_average_royalties_for_last_period(year,month)
      if month == 1
        month = 12
        year = year -1
      else
        month = month -1
      end
      RemittancesQuery.new.total_average_royalties_for_month(year,month)
    end

    def get_average_royalties_for_last_year(year,month)
      year = year -1
      RemittancesQuery.new.total_average_royalties_for_month(year,month)
    end    
  end
end