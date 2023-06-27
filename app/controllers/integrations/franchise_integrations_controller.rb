class Integrations::FranchiseIntegrationsController < ApiController
	include ApiKeyAuthenticatable

  # Require API key authentication
  before_action :authenticate_with_api_key, only: %i[update show index]
	before_action :set_franchise, only: [:update, :show]

	def update
		fp = franchise_params

		@franchise.assign_attributes(fp)

		#set_dates(fp)

		@franchise.save!

		render json: @franchise
	end

	def create
		fp = franchise_params
		@new_franchise = Franchise.new
		@new_franchise.assign_attributes(fp)
		# By default we make those USA, compliant and active
		@new_franchise.area = "1"
		@new_franchise.region = 20
		@new_franchise.inactive = 0
		@new_franchise.non_compliant = 0
		@new_franchise.save!
		render json: @new_franchise
	end

	def show
		render json: @franchise
	end

	def index
		@frans = Franchise.order(franchise_number: :asc)
		if franchise_index_params[:include_inactives].to_i == 0
			@frans = @frans.where(inactive: 0)
		end

		render json: @frans
	end


	private

	def set_franchise
		@franchise = Franchise.find_by!(franchise_number: params[:id])
	end

	def franchise_params
		params.require(:franchise)
          .permit(:area, :mast, :region, :franchise_number, :office, :firm_id,
                  :lastname, :firstname, :initial, :salutation, :address,
                  :address2, :city, :state, :zip_code, :ship_address, :ship_address2,
                  :ship_city, :ship_state, :ship_zip_code, :home_address,
                  :home_address2, :home_city, :home_state, :home_zip_code,
                  :phone, :phone2, :mobile, :fax, :email, :alt_email,
                  :start_date, :renew_date, :salesman, :territory,
                  :non_compliant, :non_compliant_reason, :prior_year_rebate,
                  :advanced_rebate, :minimum_royalty, :show_exempt_collect, :term_date,
                  :term_reason, :inactive)

	end

	def franchise_index_params
		params.require(:franchise)
		.permit(:include_inactives)
	end

  def set_dates(fp)
    @franchise.start_date = Date.strptime(fp[:start_date],I18n.translate('date.formats.default')) unless fp[:start_date].blank?
    @franchise.renew_date = Date.strptime(fp[:renew_date],I18n.translate('date.formats.default')) unless fp[:renew_date].blank?
    @franchise.term_date = Date.strptime(fp[:term_date], I18n.translate('date.formats.default')) unless fp[:term_date].blank?
  end

end