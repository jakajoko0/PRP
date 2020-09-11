class FranchisesQuery

	def initialize(relation = Franchise.all)
		@relation = relation
	end

	def franchise_list_sorted(inactives,sort)
		wheretext = inactives == 0 ? 'inactive = 0' : ''
		@relation.where(wheretext).order(sort)
	end

	private

	  

	
	


end