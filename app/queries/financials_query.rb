class FinancialsQuery

  TIERS = [{tier_number: 1, filter: "total_revenue >= 500000"},
           {tier_number: 2, filter: "total_revenue >= 300000 AND total_revenue <= 499999"},
           {tier_number: 3, filter: "total_revenue >= 100000 AND total_revenue <= 299000"},
           {tier_number: 4, filter: "total_revenue < 100000"}]

	def initialize(relation = Financial.all)
		@relation = relation
	end


	def reporting_status(year,status,sort)
	  start_date = Date.new(year,1,1)
	  sql = <<-SQL 
		  WITH report_status as (SELECT franchises.franchise_number as fran, franchises.lastname, franchises.firstname,
          (select count(*) from financials where financials.franchise_id = franchises.id and year = ?) as status
          from franchises
          WHERE inactive = 0
          and term_date is NULL
          and start_date < ?)
          Select fran, lastname, firstname, status
          From report_status
        SQL

      case status
      when 1
        where = "WHERE status = 1"
      when 2
        where = "WHERE status = 0"
      when 3
        where = ""
      end

      sql += where
      sql += "order by #{sort};"

      Financial.find_by_sql([sql,year,start_date])
    end

    def count_averages_report(franchise, year, sort)
      if sort == 'monthly_clients' || sort == 'average_monthly_fees'
        sort += " DESC"
      end
      sql = <<-SQL 
        SELECT 1 as sort_column, 
        financials.monthly_clients, 
        financials.total_monthly_fees, 
        cast(total_monthly_fees as float) / CASE monthly_clients WHEN 0 THEN cast(1 as float) ELSE cast(monthly_clients as float) END as average_monthly_fees,
        financials.quarterly_clients,
        financials.total_quarterly_fees,
        cast(total_quarterly_fees as float) / CASE quarterly_clients WHEN 0 THEN cast(1 as float) ELSE cast(quarterly_clients as float) END as average_quarterly_fees,
        financials.ind_tax_returns,
        financials.ind_tax_returns_revenues,
        cast(ind_tax_returns_revenues as float) / CASE ind_tax_returns WHEN 0 THEN cast(1 as float) ELSE cast(ind_tax_returns as float) END as average_ind_tax_return,
        financials.entity_tax_returns,
        financials.entity_tax_returns_revenues,
        cast(entity_tax_returns_revenues as float) / CASE entity_tax_returns WHEN 0 THEN cast(1 as float) ELSE cast(entity_tax_returns as float) END as average_entity_tax_return,
        financials.id as unique_id,
        franchises.franchise_number as franchise_number,
        franchises.lastname as lastname,
        franchises.firstname as firstname
        FROM financials, franchises
        WHERE financials.franchise_id = franchises.id
        AND financials.year = #{year}
      SQL
    
      if franchise != -1 
        sql = sql + "AND franchises.id = #{franchise}"
      end
   
      sql = sql + "
      UNION  
      SELECT 2 as sort_column, 
      SUM(financials.monthly_clients) as monthly_clients, 
      SUM(financials.total_monthly_fees) as total_monthly_fees, 
      SUM(cast(total_monthly_fees as float) / CASE monthly_clients WHEN 0 THEN cast(1 as float) ELSE cast(monthly_clients as float) END) as average_monthly_fees,
      SUM(financials.quarterly_clients) as quarterly_clients,
      SUM(financials.total_quarterly_fees) as total_quarterly_fees, 
      SUM(cast(total_quarterly_fees as float) / CASE quarterly_clients WHEN 0 THEN cast(1 as float) ELSE cast(quarterly_clients as float) END) as average_quarterly_fees,
      SUM(financials.ind_tax_returns) as ind_tax_returns,
      SUM(financials.ind_tax_returns_revenues) as ind_tax_returns_revenues,
      SUM(cast(ind_tax_returns_revenues as float) / CASE ind_tax_returns WHEN 0 THEN cast(1 as float) ELSE cast(ind_tax_returns as float) END) as average_ind_tax_returns,
      SUM(financials.entity_tax_returns) as entity_tax_returns,
      SUM(financials.entity_tax_returns_revenues) as entity_tax_returns_revenues,
      SUM(cast(entity_tax_returns_revenues as float) / CASE entity_tax_returns WHEN 0 THEN cast(1 as float) ELSE cast(entity_tax_returns as float) END) as average_entity_tax_returns,
      99999 as unique_id,
      'XXX' as fran_number,
      'TOTAL LAST' as lastname,
      'TOTAL FIRST' as firstname
      FROM financials
      WHERE year = #{year}
      ORDER BY sort_column ASC, #{sort}"
      Financial.find_by_sql([sql])
    end


    def aggregation_report(franchise, year, sort)
      if sort == 'total_revenue'
        sort += " DESC"
      end

      sql = "
      WITH aggregation AS ((
      SELECT 
       financials.acct_monthly, 
       financials.acct_startup, 
       financials.acct_backwork, 
       financials.tax_prep, 
       financials.payroll_processing,
       financials.other_consult,
       financials.erc,
       (financials.acct_monthly+ 
       financials.acct_startup+ 
       financials.acct_backwork+ 
       financials.tax_prep+ 
       financials.payroll_processing+
       financials.other_consult+
       financials.erc) as total_revenue,
       financials.payroll_operation, 
       financials.owner_wages, 
       financials.owner_payroll_taxes, 
       financials.payroll_taxes_ben_ee,
       (financials.payroll_operation+ 
       financials.owner_wages+ 
       financials.owner_payroll_taxes+ 
       financials.payroll_taxes_ben_ee) as total_payroll_expense, 
       financials.insurance_business, 
       financials.supplies, 
       financials.legal_accounting, 
       financials.marketing, 
       financials.rent, 
       financials.outside_labor, 
       financials.vehicles, 
       financials.travel, 
       financials.utilities, 
       financials.licenses_taxes, 
       financials.postage, 
       financials.repairs, 
       financials.interests, 
       financials.meals_entertainment, 
       financials.bank_charges, 
       financials.contributions, 
       financials.office, 
       (financials.miscellaneous + financials.other_expense) as miscellaneous, 
       financials.equipment_lease, 
       financials.dues_subscriptions, 
       financials.bad_debt, 
       financials.property_tax, 
       financials.telephone_data_internet, 
       financials.royalties,
       financials.marketing_material,
       (financials.continuing_ed + financials.software) as accounting_costs, 
       financials.owner_health_ins, 
       financials.owner_vehicle, 
       financials.owner_ira_contrib, 
       (financials.amortization +    financials.depreciation) as depreciation_and_amortization, 
       financials.payroll_process_fees, 
       (financials.payroll_operation+ 
       financials.owner_wages+ 
       financials.owner_payroll_taxes+ 
       financials.payroll_taxes_ben_ee+ 
       financials.insurance_business+ 
       financials.supplies+ 
       financials.legal_accounting+ 
       financials.marketing+ 
       financials.rent+ 
       financials.outside_labor+ 
       financials.vehicles+ 
       financials.travel+ 
       financials.utilities+ 
       financials.licenses_taxes+ 
       financials.postage+ 
       financials.repairs+ 
       financials.interests+ 
       financials.meals_entertainment+ 
       financials.bank_charges+ 
       financials.contributions+ 
       financials.office+ 
       financials.miscellaneous+ 
       financials.equipment_lease+ 
       financials.dues_subscriptions+ 
       financials.bad_debt+ 
       financials.continuing_ed+ 
       financials.property_tax+ 
       financials.telephone_data_internet+ 
       financials.software+ 
       financials.royalties+
       financials.marketing_material+
       financials.owner_health_ins+ 
       financials.owner_vehicle+ 
       financials.owner_ira_contrib+ 
       financials.amortization+ 
       financials.depreciation+ 
       financials.payroll_process_fees) as total_expense,
       (financials.other_income +  financials.interest_income) as non_padgett_revenues, 
       financials.net_gain_asset, 
       financials.casualty_gain, 
       financials.prov_income_tax, 
       financials.other1_desc as other1_desc, 
       financials.other1, 
       financials.other2_desc as other2_desc,
       financials.other2, 
       financials.other3_desc as other3_desc, 
       financials.other3, 
       financials.id as unique_id, 
       franchises.franchise_number as franchise_number, 
       franchises.lastname as lastname, 
       franchises.firstname as firstname,
       franchises.address as address,
       franchises.city as city,
       franchises.state as state,
       franchises.zip_code as zip_code
       FROM financials,franchises
       WHERE financials.franchise_id = franchises.id
       AND financials.year = #{year}"

       if franchise != -1 
        sql = sql + "AND franchises.id = #{franchise}"
       end

       sql = sql + ")) "

       TIERS.each do |tier|
        sql = sql + "
        SELECT #{tier[:tier_number]} as tier,
        1 as sort_column, 
        aggregation.acct_monthly,
        aggregation.acct_startup,
        aggregation.acct_backwork,
        aggregation.tax_prep,
        aggregation.payroll_processing,
        aggregation.other_consult,
        aggregation.erc,
        aggregation.total_revenue,
        aggregation.payroll_operation,
        aggregation.owner_wages,
        aggregation.owner_payroll_taxes, 
        aggregation.payroll_taxes_ben_ee, 
        aggregation.total_payroll_expense,
        aggregation.insurance_business, 
        aggregation.supplies, 
        aggregation.legal_accounting, 
        aggregation.marketing, 
        aggregation.rent, 
        aggregation.outside_labor, 
        aggregation.vehicles, 
        aggregation.travel, 
        aggregation.utilities, 
        aggregation.licenses_taxes, 
        aggregation.postage, 
        aggregation.repairs, 
        aggregation.interests,
        aggregation.meals_entertainment, 
        aggregation.bank_charges,
        aggregation.contributions, 
        aggregation.office, 
        aggregation.miscellaneous, 
        aggregation.equipment_lease, 
        aggregation.dues_subscriptions, 
        aggregation.bad_debt, 
        aggregation.accounting_costs,
        aggregation.property_tax, 
        aggregation.telephone_data_internet, 
        aggregation.royalties,
        aggregation.marketing_material,
        aggregation.owner_health_ins, 
        aggregation.owner_vehicle, 
        aggregation.owner_ira_contrib, 
        aggregation.depreciation_and_amortization,
        aggregation.payroll_process_fees,
        aggregation.total_expense,
        aggregation.non_padgett_revenues,
        aggregation.net_gain_asset, 
        aggregation.casualty_gain,
        aggregation.prov_income_tax, 
        aggregation.other1_desc as other1_desc, 
        aggregation.other1, 
        aggregation.other2_desc as other2_desc,
        aggregation.other2, 
        aggregation.other3_desc as other3_desc, 
        aggregation.other3, 
        aggregation.unique_id,
        aggregation.franchise_number,
        aggregation.lastname,
        aggregation.firstname,
        aggregation.address,
        aggregation.city,
        aggregation.state,
        aggregation.zip_code,
        1 as franchise_count
        FROM aggregation
        WHERE #{tier[:filter]}
        UNION 
        SELECT #{tier[:tier_number]} as tier,
        2 as sort_column, 
        COALESCE(SUM(aggregation.acct_monthly),0) as acct_monthly,
        COALESCE(SUM(aggregation.acct_startup),0) as acct_startup,
        COALESCE(SUM(aggregation.acct_backwork),0) as acct_backwork,
        COALESCE(SUM(aggregation.tax_prep),0) as tax_prep,
        COALESCE(SUM(aggregation.payroll_processing),0) as payroll_processing,
        COALESCE(SUM(aggregation.other_consult),0) as other_consult,
        COALESCE(SUM(aggregation.erc),0) as erc,
        COALESCE(SUM(aggregation.total_revenue),0) as total_revenue,
        COALESCE(SUM(aggregation.payroll_operation),0) as payroll_operation,
        COALESCE(SUM(aggregation.owner_wages),0) as owner_wages,
        COALESCE(SUM(aggregation.owner_payroll_taxes),0) as owner_payroll_taxes, 
        COALESCE(SUM(aggregation.payroll_taxes_ben_ee),0) as payroll_taxes_ben_ee, 
        COALESCE(SUM(aggregation.total_payroll_expense),0) as total_payroll_expense,
        COALESCE(SUM(aggregation.insurance_business),0) as insurance_business, 
        COALESCE(SUM(aggregation.supplies),0) as supplies, 
        COALESCE(SUM(aggregation.legal_accounting),0) as legal_accounting, 
        COALESCE(SUM(aggregation.marketing),0) as marketing, 
        COALESCE(SUM(aggregation.rent),0) as rent, 
        COALESCE(SUM(aggregation.outside_labor),0) as outside_labor, 
        COALESCE(SUM(aggregation.vehicles),0) as vehicles, 
        COALESCE(SUM(aggregation.travel),0) as travel, 
        COALESCE(SUM(aggregation.utilities),0) as utilities, 
        COALESCE(SUM(aggregation.licenses_taxes),0) as licenses_taxes, 
        COALESCE(SUM(aggregation.postage),0) as postage, 
        COALESCE(SUM(aggregation.repairs),0) as repairs, 
        COALESCE(SUM(aggregation.interests),0) as interests,
        COALESCE(SUM(aggregation.meals_entertainment),0) as meals_entertainment, 
        COALESCE(SUM(aggregation.bank_charges),0) as bank_charges,
        COALESCE(SUM(aggregation.contributions),0) as contribution, 
        COALESCE(SUM(aggregation.office),0) as office, 
        COALESCE(SUM(aggregation.miscellaneous),0) as miscellaneous, 
        COALESCE(SUM(aggregation.equipment_lease),0) as equipment_lease, 
        COALESCE(SUM(aggregation.dues_subscriptions),0) as dues_subscription, 
        COALESCE(SUM(aggregation.bad_debt),0) as bad_debt, 
        COALESCE(SUM(aggregation.accounting_costs),0) as accounting_costs,
        COALESCE(SUM(aggregation.property_tax),0) as property_tax, 
        COALESCE(SUM(aggregation.telephone_data_internet),0) as telephone_data_internet, 
        COALESCE(SUM(aggregation.royalties),0) as royalties,
        COALESCE(SUM(aggregation.marketing_material),0) as marketing_material,
        COALESCE(SUM(aggregation.owner_health_ins),0) as owner_health_ins, 
        COALESCE(SUM(aggregation.owner_vehicle),0) as owner_vehicle, 
        COALESCE(SUM(aggregation.owner_ira_contrib),0) as owner_ira_contrib, 
        COALESCE(SUM(aggregation.depreciation_and_amortization),0) as depreciation_and_amortization,
        COALESCE(SUM(aggregation.payroll_process_fees),0) as payroll_process_fees,
        COALESCE(SUM(aggregation.total_expense),0) as total_expense,
        COALESCE(SUM(aggregation.non_padgett_revenues),0) as non_padgett_revenues,
        COALESCE(SUM(aggregation.net_gain_asset),0) as net_gain_asset, 
        COALESCE(SUM(aggregation.casualty_gain),0) as casualty_gain, 
        COALESCE(SUM(aggregation.prov_income_tax),0) as prov_income_tax, 
        'SUM OF OTHER 1' as other1_desc, 
        COALESCE(SUM(aggregation.other1),0) as other1, 
        'SUM OF OTHER 2' as other2_desc,
        COALESCE(SUM(aggregation.other2),0) as other2, 
        'SUM OF OTHER 3' as other3_desc, 
        COALESCE(SUM(aggregation.other3),0) as other3, 
        999999.unique_id,
        '' as franchise_number,
        'Totals for Tier #{tier[:tier_number]}' as lastname,
        '' as firstname,
        '' as address,
        '' as city,
        '' as state,
        '' as zip_code,
        COUNT(*) as franchise_count
        FROM aggregation
        WHERE #{tier[:filter]}
        AND EXISTS( SELECT * FROM aggregation WHERE #{tier[:filter]}) UNION "
       end

       sql.delete_suffix!("UNION ")

       sql = sql+ "ORDER BY tier ASC, sort_column ASC, #{sort}"

       Financial.find_by_sql([sql])

       #return sql;
       

    end


end