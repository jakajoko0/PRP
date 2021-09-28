class WebsitePreferencesQuery

	def initialize(relation = WebsitePreference.all)
		@relation = relation
	end

	def web_options_listing(sortby)
    case sortby
    when 1
      ordertext = 'franchises.franchise ASC'
    when 2  
      ordertext = 'franchises.lastname ASC'  
    when 3
      ordertext = 'website_options.updated_at DESC' 
    end
    WebsiteOption.includes("franchise").all.order(ordertext)

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