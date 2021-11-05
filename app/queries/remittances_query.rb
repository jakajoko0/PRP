class RemittancesQuery

	def initialize(relation = Remittance.all)
		@relation = relation
	end

	def total_collections_for_month(year,month)
		@relation.posted.where(year: year, month: month).sum("accounting + backwork + consulting + excluded + other1 + other2 + payroll + setup + tax_preparation")
	end

	def franchise_collections_for_month(year,month,franchise)
		@relation.posted.where(year: year, month: month, franchise_id: franchise).sum("accounting + backwork + consulting + excluded + other1 + other2 + payroll + setup + tax_preparation")
	end

	def franchise_ytd_collections(year,month,franchise)
		@relation.posted.where("year = ? AND month <= ? AND franchise_id = ?", year, month,franchise).sum("accounting + backwork + consulting + excluded + other1 + other2 + payroll + setup + tax_preparation")
	end

	def total_royalties_for_month(year,month)
		@relation.posted.where(year: year, month: month).sum(:royalty)
	end

	def total_average_collections_for_month(year,month)
		@relation.posted.where(year: year, month: month).average("accounting + backwork + consulting + excluded + other1 + other2 + payroll + setup + tax_preparation") || 0
	end

	def ytd_average_collections(year,month)
	  sums = Remittance.select("SUM(accounting + backwork + consulting  + other1 + other2 + payroll + setup + tax_preparation) AS collections, franchise_id AS franchise_id").where("year = ? and month <= ? AND status = ?", year,month,1).group("franchise_id").order("franchise_id")
    if sums.length > 0
      avg = sums.collect(&:collections).sum.to_f/sums.length
    else
      avg = 0.00
    end

  end

	def total_average_collections_for_month(year,month)
		@relation.posted.where(year: year, month: month).average("accounting + backwork + consulting + excluded + other1 + other2 + payroll + setup + tax_preparation") || 0
	end


	def total_average_royalties_for_month(year,month)
		@relation.posted.where(year: year, month: month).average(:royalty) || 0
	end

	def total_royalties_by_state(year,month)
		res = @relation.joins(:franchise).select("franchises.state, SUM(royalty) as total_royalty").where(year: year, month: month).order("franchises.state").group("franchises.state")
		res.map{|record| ["US-"+record.state, record.total_royalty] }
	end

	def total_collections_for_graph(franchise, year, month)
		@relation.posted.where("franchise_id = ? AND month = ? and year = ?", franchise, month , year).sum('accounting + backwork + consulting + other1 + other2 + payroll + setup + tax_preparation')
	end

	def total_collections_by_category(year,month)
		res = @relation.posted.select("COALESCE(SUM(accounting),0) as accounting, COALESCE(SUM(backwork),0) as backwork, COALESCE(SUM(consulting),0) as consulting, COALESCE(SUM(excluded),0) as excluded, COALESCE(SUM(other1),0) as other1, COALESCE(SUM(other2),0) as other2, COALESCE(SUM(payroll),0) as payroll, COALESCE(SUM(setup),0) as setup, COALESCE(SUM(tax_preparation),0) as tax_preparation, COALESCE(SUM(payroll),0) as payroll").where(year: year, month: month)[0]
		return [["Accounting", res.accounting],
	          ["Tax", res.tax_preparation],
	          ["Consultation", res.consulting],
	          ["Payroll", res.payroll],
	          ["Setup", res.setup],
	          ["Backwork", res.backwork],
	          ["Other", (res.other1+res.other2)],
	          ["Excluded", res.excluded] ]
	end

	def collections_monthly_ranking(year, month, franchise_id)
    #First we select franchises with the sum of their collections for the target year and month
    #Ordered by descending collection. 
    res = Franchise.joins("LEFT JOIN remittances ON remittances.franchise_id = franchises.id").select("franchises.id,sum(remittances.accounting+ remittances.backwork + remittances.consulting + remittances.other1+ remittances.other2 + remittances.payroll + remittances.setup + remittances.tax_prep ) as collect").where("year = ? and month = ? and posted = ?",year, month,1).group("franchises.id").order("collect DESC")
    #Then we find the position of the current franchise by using the map method
    pos = res.map(&:id).index(franchise_id)
    #If not found, because nothing entered yet, if found return position 
    if pos.nil?
      return 'NA'
    else
      return (pos+1).to_s+' / '+(res.length).to_s
    end
  end

  #Method that calculates the current year to date ranking for a specificfranchise
  def collections_ytd_ranking(year,month,franchise_id)
    #First we select franchises with the sum of their collections for the  year
    #Ordered by descending collection. 
    res = Franchise.joins("LEFT JOIN remittances ON remittances.franchise_id = franchises.id").select("franchises.id,sum(remittances.accounting + remittances.backwork + remittances.consulting +  remittances.other1 + remittances.other2 + remittances.payroll + remittances.setup + remittances.tax_prep) as collect").where("year = ? and posted = ?" ,year,1).group("franchises.id").order("collect DESC")
    #Then we find the position of the current franchise by using the map method
    pos = res.map(&:id).index(franchise_id)

    if pos.nil?
      return 'NA'
    #If not found, because nothing entered yet, if found return position 
    else
      return (pos+1).to_s+' / '+(res.length).to_s
    end
  end

	def monthly_royalties_for_year(year)
		sql = <<-SQL
		  WITH period_list AS (select * from generate_series(1,12) num)
      SELECT pl.num as month,
      (SELECT COALESCE(SUM(remittances.royalty),0) FROM remittances where year = ? and month=pl.num) as royalty
      FROM period_list pl;
    SQL

    res = @relation.find_by_sql([sql,year])
    res.map{|r| [r.month, r.royalty]}

	end




end