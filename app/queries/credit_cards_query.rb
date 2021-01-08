class CreditCardsQuery

	def initialize(relation = CreditCard.all)
		@relation = relation
	end

	def credit_card_list_sorted(inactives,sort)
		wheretext = inactives == 0 ? 'franchises.inactive = 0' : ''
		@relation.joins(:franchise).select("franchises.franchise_number, franchises.lastname, franchises.firstname, credit_cards.card_type as name, credit_cards.last_four as last_four, 'C' as type").where(wheretext).order(sort)
	end

	def no_credit_cards_on_file(inactives,sort)
		wheretext = inactives == 0 ? 'franchises.inactive = 0' : ''
		Franchise.where(wheretext).where.missing(:credit_cards).order(sort)
  end
	


end