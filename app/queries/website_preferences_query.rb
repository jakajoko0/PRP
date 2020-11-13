class WebsitePreferencesQuery

	def initialize(relation = WebsitePreference.all)
		@relation = relation
	end

	def website_preferences_list_sorted(sort)
		if sort == "website_preferences.updated_at"
			sort+=" DESC"
		end

		records = @relation.includes(:franchise).order(sort)

	end

	def website_preferences_missing(inactives,sort)
		wheretext = inactives == 0 ? 'franchises.inactive = 0' : ''
		Franchise.left_outer_joins(:website_preference).where(website_preferences: {id: nil}).where(wheretext).order(sort)
	end

	private

	  

	
	


end