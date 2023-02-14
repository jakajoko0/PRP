class Integrations::FinancialsIntegrationsController < ApiController
  include ApiKeyAuthenticatable

  # Require API key authentication
  before_action :authenticate_with_api_key, only: %i[show index specific]
	
	def show
	  franchise = Franchise.find_by!(franchise_number: params[:id])
		@financials = Financial.for_franchise(franchise.id).joins(:franchise).select(final_attributes)

		render json: @financials
	end

	def index
		@all_financial = Financial.joins(:franchise).select(final_attributes).order("franchise_number ASC, year DESC")
		render json: @all_financial
	end

	def specific
		@financials = Financial.all
		if financials_params[:franchise_number].present?
			franchise = Franchise.find_by!(franchise_number: financials_params[:franchise_number])
			@financials = @financials.for_franchise(franchise.id)
		end

		if financials_params[:year].present?
			@financials = @financials.for_specific_year(financials_params[:year].to_i)
    end

    render json: @financials.joins(:franchise).select(final_attributes)
	end

	private

	def financials_params
		params.permit(:franchise_number, :year)
	end

	def franchise_attributes
		"franchises.franchise_number, franchises.firstname, franchises.lastname"
	end

	def financial_attributes
		Financial.attribute_names.map{|fa| "financials.#{fa}"}
  end

  def final_attributes
  	franchise_attributes + "," + financial_attributes.join(",")
  end

end