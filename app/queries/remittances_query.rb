class RemittancesQuery

	def initialize(relation = Remittance.all)
		@relation = relation
	end

	def total_collections_for_month(year,month)
		@relation.posted.where(year: year, month: month).sum("accounting + backwork + consulting + excluded + other1 + other2 + payroll + setup + tax_preparation")
	end

	def total_royalties_for_month(year,month)
		@relation.posted.where(year: year, month: month).sum(:royalty)
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

	def total_collections_by_category(year,month)
		res = @relation.posted.select("COALESCE(SUM(accounting),0) as accounting, COALESCE(SUM(backwork),0) as backwork, COALESCE(SUM(consulting),0) as consulting, COALESCE(SUM(excluded),0) as excluded, COALESCE(SUM(other1),0) as other1, COALESCE(SUM(other2),0) as other2, COALESCE(SUM(payroll),0) as payroll, COALESCE(SUM(setup),0) as setup, COALESCE(SUM(tax_preparation),0) as tax_preparation").where(year: year, month: month)[0]
		return [["Accounting", res.accounting],
	          ["Tax", res.tax_preparation],
	          ["Consultation", res.consulting],
	          ["Setup", res.setup],
	          ["Backwork", res.backwork],
	          ["Other", (res.other1+res.other2)],
	          ["Excluded", res.excluded]]
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