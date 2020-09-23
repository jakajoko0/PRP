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

	
	private

	  

	
	


end