class BankAccountsQuery

	def initialize(relation = BankAccount.all)
		@relation = relation
	end

	def bank_account_list_sorted(inactives,sort)
		wheretext = inactives == 0 ? 'franchises.inactive = 0' : ''
		@relation.joins(:franchise).select("franchises.franchise_number, franchises.lastname, franchises.firstname, bank_accounts.bank_name as name,  bank_accounts.last_four as last_four, 'B' as type").where(wheretext).order(sort)
	end

	def no_bank_account_on_file(inactives,sort)
		wheretext = inactives == 0 ? 'franchises.inactive = 0' : ''
		Franchise.where(wheretext).where.missing(:bank_accounts).order(sort)
  end

	


end