class FranchisesQuery

	def initialize(relation = Franchise.all)
		@relation = relation
	end

	def franchise_list_sorted(inactives,sort)
		wheretext = inactives == 0 ? 'inactive = 0' : ''
		@relation.where(wheretext).order(sort)
	end

	def franchise_expiring(start_date, end_date)
		@relation.where(renew_date: start_date..end_date).order("renew_date ASC")
	end

	def using_advanced_rebates
		@relation.where.not(advanced_rebate: -Float::INFINITY..0.00).order("lastname")
	end

	def using_prior_rebates
		@relation.where.not(prior_year_rebate: -Float::INFINITY..0.00).order("lastname")
	end

	#Method that calculates the current month ranking for a specific franchise
  def get_monthly_ranking(franchise_id, year, month)
    #First we select franchises with the sum of their collections for the target year and month
    #Ordered by descending collection. 
    res = Franchise.joins("LEFT JOIN remittances ON remittances.franchise_id = franchises.id").select("franchises.id,sum(remittances.accounting+ remittances.backwork + remittances.consulting + remittances.other1+ remittances.other2 + remittances.payroll + remittances.setup + remittances.tax_preparation ) as collect").where("year = ? and month = ? and status = ?",year, month,1).group("franchises.id").order("collect DESC")
    #Then we find the position of the current franchise by using the map method
    pos = res.map(&:id).index(franchise_id)
    #If not found, because nothing entered yet, if found return position 
    if pos.nil?
      return 'NA'
    else
      return (pos+1).to_s+' / '+(res.length).to_s
    end
  end

  def get_ytd_ranking(franchise_id, year, month)
    #First we select franchises with the sum of their collections for the  year
    #Ordered by descending collection. 
    res = Franchise.joins("LEFT JOIN remittances ON remittances.franchise_id = franchises.id").select("franchises.id,sum(remittances.accounting + remittances.backwork + remittances.consulting +  remittances.other1 + remittances.other2 + remittances.payroll + remittances.setup + remittances.tax_preparation) as collect").where("year = ? and month <= ? AND status = ?" ,year,month,1).group("franchises.id").order("collect DESC")
    #Then we find the position of the current franchise by using the map method
    pos = res.map(&:id).index(franchise_id)

    if pos.nil?
      return 'NA'
    #If not found, because nothing entered yet, if found return position 
    else
      return (pos+1).to_s+' / '+(res.length).to_s
    end
  end

  def get_royalty_balance(franchise_id)
    credits = PrpTransaction.where(franchise_id: franchise_id, trans_type: ["payment","credit"]).sum(:amount)
    debits = PrpTransaction.where(franchise_id: franchise_id, trans_type: ["receivable"]).sum(:amount)
    return debits - credits  
  end


	


end