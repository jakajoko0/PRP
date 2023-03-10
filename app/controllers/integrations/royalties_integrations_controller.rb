class Integrations::RoyaltiesIntegrationsController < ApiController
  include ApiKeyAuthenticatable

  # Require API key authentication
  before_action :authenticate_with_api_key, only: %i[index specific]
	

	def index
		@all_royalties = Remittance.joins(:franchise).select(final_attributes).where("franchises.inactive = 0").order("franchises.franchise_number ASC, year ASC, month ASC")
		render json: @all_royalties
	end

	def specific
		@royalties = Remittance.all
		if royalties_params[:franchise_number].present?
			franchise = Franchise.find_by!(franchise_number: royalties_params[:franchise_number])
			@royalties = @royalties.for_franchise(franchise.id)
		end

		if royalties_params[:year].present?
			@royalties = @royalties.for_specific_year(royalties_params[:year].to_i)
    end

    if royalties_params[:month].present?
    	@royalties = @royalties.for_specific_month(royalties_params[:month].to_i)
    end

    render json: @royalties.joins(:franchise).select(final_attributes).order("franchises.franchise_number, remittances.year, remittances.month")
	end

	private

	def royalties_params
		params.permit(:franchise_number, :year, :month)
	end

	def franchise_attributes
		"franchises.franchise_number, franchises.firstname, franchises.lastname"
	end

	def royalty_attributes
		Remittance.attribute_names.map{|fa| "remittances.#{fa}"}
  end

  def final_attributes
  	franchise_attributes + "," + royalty_attributes.join(",")
  end

end