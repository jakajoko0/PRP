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
        SUM(aggregation.acct_monthly) as acct_monthly,
        SUM(aggregation.acct_startup) as acct_startup,
        SUM(aggregation.acct_backwork) as acct_backwork,
        SUM(aggregation.tax_prep) as tax_prep,
        SUM(aggregation.payroll_processing) as payroll_processing,
        SUM(aggregation.other_consult) as other_consult,
        SUM(aggregation.erc) as erc,
        SUM(aggregation.total_revenue) as total_revenue,
        SUM(aggregation.payroll_operation) as payroll_operation,
        SUM(aggregation.owner_wages) as owner_wages,
        SUM(aggregation.owner_payroll_taxes) as owner_payroll_taxes, 
        SUM(aggregation.payroll_taxes_ben_ee) as payroll_taxes_ben_ee, 
        SUM(aggregation.total_payroll_expense) as total_payroll_expense,
        SUM(aggregation.insurance_business) as insurance_business, 
        SUM(aggregation.supplies) as supplies, 
        SUM(aggregation.legal_accounting) as legal_accounting, 
        SUM(aggregation.marketing) as marketing, 
        SUM(aggregation.rent) as rent, 
        SUM(aggregation.outside_labor) as outside_labor, 
        SUM(aggregation.vehicles) as vehicles, 
        SUM(aggregation.travel) as travel, 
        SUM(aggregation.utilities) as utilities, 
        SUM(aggregation.licenses_taxes) as licenses_taxes, 
        SUM(aggregation.postage) as postage, 
        SUM(aggregation.repairs) as repairs, 
        SUM(aggregation.interests) as interests,
        SUM(aggregation.meals_entertainment) as meals_entertainment, 
        SUM(aggregation.bank_charges) as bank_charges,
        SUM(aggregation.contributions) as contribution, 
        SUM(aggregation.office) as office, 
        SUM(aggregation.miscellaneous) as miscellaneous, 
        SUM(aggregation.equipment_lease) as equipment_lease, 
        SUM(aggregation.dues_subscriptions) as dues_subscription, 
        SUM(aggregation.bad_debt) as bad_debt, 
        SUM(aggregation.accounting_costs) as accounting_costs,
        SUM(aggregation.property_tax) as property_tax, 
        SUM(aggregation.telephone_data_internet) as telephone_data_internet, 
        SUM(aggregation.royalties) as royalties,
        SUM(aggregation.marketing_material) as marketing_material,
        SUM(aggregation.owner_health_ins) as owner_health_ins, 
        SUM(aggregation.owner_vehicle) as owner_vehicle, 
        SUM(aggregation.owner_ira_contrib) as owner_ira_contrib, 
        SUM(aggregation.depreciation_and_amortization) as depreciation_and_amortization,
        SUM(aggregation.payroll_process_fees) as payroll_process_fees,
        SUM(aggregation.total_expense) as total_expense,
        SUM(aggregation.non_padgett_revenues) as non_padgett_revenues,
        SUM(aggregation.net_gain_asset) as net_gain_asset, 
        SUM(aggregation.casualty_gain) as casualty_gain, 
        SUM(aggregation.prov_income_tax) as prov_income_tax, 
        'SUM OF OTHER 1' as other1_desc, 
        SUM(aggregation.other1) as other1, 
        'SUM OF OTHER 2' as other2_desc,
        SUM(aggregation.other2) as other2, 
        'SUM OF OTHER 3' as other3_desc, 
        SUM(aggregation.other3) as other3, 
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
        WHERE #{tier[:filter]} UNION "
       end

       sql.delete_suffix!("UNION ")

       sql = sql+ "ORDER BY tier ASC, sort_column ASC, #{sort}"

       Financial.find_by_sql([sql])

       #return sql;
       

    end


end