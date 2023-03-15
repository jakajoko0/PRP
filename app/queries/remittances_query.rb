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
	

	def royalty_missing_list(franchise, from_year, from_month, to_year, to_month, start_date, end_date)
		reports = Remittance.joins(:franchise)
		.select("franchise_id, year, month")
		.where("remittances.franchise_id = ? AND remittances.year *12 + remittances.month BETWEEN ? and ?",franchise.id,from_year*12+from_month, to_year*12+to_month)
		.order("franchises.lastname, franchises.firstname, franchises.franchise_number")
		unique_reports = reports.pluck(:franchise_id, :year, :month)
		franchise_start = (franchise.accountants.first.start_date if franchise.accountants.first) || franchise.start_date
		date_to_use = [franchise_start, start_date].max
		#Build an array of all possible year and months reports should have been submitted
    periods = (date_to_use..end_date).map{|d| [franchise.id, d.year, d.month]}.uniq
    missing = periods - unique_reports

	end

	def collections_by_date_range(start_date, end_date, consolidate = 0, consol_list = [])
    if consolidate == 1 && consol_list.length > 0  
      non_consolidated =  Remittance.joins(:franchise).group("remittances.month, remittances.year, franchises.firstname, franchises.lastname, franchises.franchise_number").select('remittances.month, remittances.year, franchises.lastname, franchises.firstname, franchises.franchise_number, sum(royalty) as royalty,sum(accounting + backwork + consulting +  other1 + other2 + payroll + setup + tax_preparation) as tot_collect, (sum(royalty)/ nullif(sum(accounting + backwork + consulting +  other1 + other2 + payroll + setup + tax_preparation),0)::float)*100 as roy_pct').where("date_posted >= ? and date_posted <= ? and remittances.fran NOT IN (?)",(start_date.to_time.beginning_of_day),(end_date.to_time.end_of_day),consol_list).order("franchises.lastname asc, remittances.year asc, remittances.month asc")
      consolidated = Remittance.joins(consolidated: :franchise).group("remittances.month, remittances.year, franchises.firstname, franchises.lastname, franchises.franchise_number").select('remittances.month, remittances.year, franchises.lastname, franchises.firstname, franchises.franchise_number, sum(royalty) as royalty,sum(accounting + backwork + consulting +  other1 + other2 + payroll + setup + tax_preparation) as tot_collect, (sum(royalty)/ nullif(sum(accounting + backwork + consulting +  other1 + other2 + payroll + setup + tax_preparation),0)::float)*100 as roy_pct').where("date_posted >= ? and date_posted <= ? and remittances.fran IN(?)",(start_date.to_time.beginning_of_day),(end_date.to_time.end_of_day),consol_list).order("franchises.lastname asc, remittances.year asc, remittances.month asc")
      Remittance.from("((#{non_consolidated.to_sql}) UNION (#{consolidated.to_sql})) AS remittances")
    else
      Remittance.joins(:franchise).group("remittances.month, remittances.year, franchises.firstname, franchises.lastname", "franchises.franchise_number").select('remittances.month, remittances.year, franchises.lastname, franchises.firstname, franchises.franchise_number, sum(royalty) as royalty,sum(accounting + backwork + consulting +  other1 + other2 + payroll + setup + tax_preparation) as tot_collect, (sum(royalty)/ nullif(sum(accounting + backwork + consulting +  other1 + other2 + payroll + setup + tax_preparation),0)::float)*100 as roy_pct').where("date_posted >= ? and date_posted <= ?",(start_date.to_time.beginning_of_day),(end_date.to_time.end_of_day)).order("franchises.lastname asc, remittances.year asc, remittances.month asc")
    end  
  end

  def colletions_summary_for_date_range(start_date, end_date, sort_by, consolidate = 0, consol_list = [])
    case sort_by
    when 1
      orderby = 'franchises.lastname, franchises.firstname'
    when 2
      orderby = 'franchises.state, franchises.lastname, franchises.firstname'
    when 3
      orderby = 'reg_group, franchises.region, franchises.lastname, franchises.firstname'
    end

    if consolidate == 1
    	non_consolidated = Remittance.joins(:franchise).
    	  group("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname").
    	  select("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname, sum(accounting + backwork + consulting + other1 + other2 + payroll + setup + tax_preparation) as collections, 0 as row_type, CASE WHEN franchises.region != '5' THEN 0 ELSE 1 END as reg_group").
    	  where('(date_posted >= ? and date_posted <= ?) AND remittances.franchise_number NOT IN (?)', start_date.to_time.beginning_of_day, end_date.to_time.end_of_day, consol_list).
    	  order(orderby)

    	consolidated = Remittance.joins(consolidated: :franchise).
        group("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname").
        select("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname, sum(accounting + backwork + consulting +  other1 + other2 + payroll + setup + tax_preparation) as collections, 0 as row_type, CASE WHEN franchises.region != '5' THEN 0 ELSE 1 END as reg_group").
        where('(date_posted >= ? and date_posted <= ?) AND remittances.franchise_number IN (?)',start_date.to_time.beginning_of_day,end_date.to_time.end_of_day, consol_list).
        order(orderby)
      Remittance.from("((#{non_consolidated.to_sql}) UNION (#{consolidated.to_sql})) AS remittances")
    else
      Remittance.joins(:franchise).group("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname").select("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname, sum(accounting + backwork + consulting +  other1 + other2 + payroll + setup + tax_preparation) as collections, 0 as row_type, CASE WHEN franchises.region != '5' THEN 0 ELSE 1 END as reg_group").
        where('date_posted >= ? and date_posted <= ?',start_date.to_time.beginning_of_day,end_date.to_time.end_of_day).
        order(orderby)
    end	
  end

  def royalty_summary_for_date_range(start_date, end_date, sort_by, consolidate = 0, consol_list = [])
    case sort_by
    when 1
      orderby = 'franchises.lastname, franchises.firstname'
    when 2
      orderby = 'franchises.state, franchises.lastname, franchises.firstname'
    when 3
      orderby = 'reg_group, franchises.region, franchises.lastname, franchises.firstname'
    end

    if consolidate == 1
      non_consolidated = Remittance.joins(:franchise).
        group("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname").
        select("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname, sum(royalty) as royalties, 0 as row_type, CASE WHEN franchises.region != '5' THEN 0 ELSE 1 END as reg_group").
        where('(date_posted >= ? and date_posted <= ?) AND remittances.franchise_number NOT IN (?)', start_date.to_time.beginning_of_day, end_date.to_time.end_of_day, consol_list).
        order(orderby)

      consolidated = Remittance.joins(consolidated: :franchise).
        group("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname").
        select("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname, sum(royalty) as royalties, 0 as row_type, CASE WHEN franchises.region != '5' THEN 0 ELSE 1 END as reg_group").
        where('(date_posted >= ? and date_posted <= ?) AND remittances.franchise_number IN (?)',start_date.to_time.beginning_of_day,end_date.to_time.end_of_day, consol_list).
        order(orderby)
      Remittance.from("((#{non_consolidated.to_sql}) UNION (#{consolidated.to_sql})) AS remittances")
    else
      Remittance.joins(:franchise).group("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname").select("franchises.region, franchises.id, franchises.state, franchises.lastname, franchises.firstname, sum(royalty) as royalties, 0 as row_type, CASE WHEN franchises.region != '5' THEN 0 ELSE 1 END as reg_group").
        where('date_posted >= ? and date_posted <= ?',start_date.to_time.beginning_of_day,end_date.to_time.end_of_day).
        order(orderby)
    end 
  end
  
  def collections_under_threshold(year, month, year2, month2, min_amount, sortby)
    case sortby
    when 1
      sort = 'franchises.lastname ASC, remittances.year ASC, remittances.month ASC'
    when 2
      sort = 'franchises.franchise_number ASC, remittances.year ASC, remittances.month ASC'
    when 3
      sort = 'collections ASC, remittances.year ASC, remittances.month ASC'
    end
  
    Remittance.joins(:franchise).
    select("franchises.firstname, franchises.lastname, franchises.franchise_number, SUM(remittances.accounting + remittances.backwork + remittances.consulting + remittances.other1 + remittances.other2 + remittances.payroll + remittances.setup + remittances.tax_preparation) as collections,  remittances.month, remittances.year").
    where('(remittances.year *12 + remittances.month BETWEEN ? and ?)',year*12+month, year2*12+month2).having("SUM(remittances.accounting + remittances.backwork + remittances.consulting + remittances.other1 + remittances.other2 + remittances.payroll + remittances.setup + remittances.tax_preparation) < ?",min_amount).
    group("franchises.lastname, franchises.firstname, franchises.franchise_number, remittances.month, remittances.year").
    order(sort) 
  end

  def collections_and_royalties_by_year(from_yr, from_mo, to_yr, to_mo)
    Remittance.group("remittances.year").
    select("remittances.year,sum(accounting + backwork + consulting +  other1 + other2 + payroll + setup + tax_preparation) as tot_collect, sum(royalty) as tot_roy").
    where("(remittances.year *12 + remittances.month BETWEEN ? and ?)", from_yr*12+from_mo, to_yr*12+to_mo).
    order("remittances.year")
  end

end