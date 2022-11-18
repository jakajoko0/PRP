class Integrations::FranchiseIntegrationsController < ApiController
	include ApiKeyAuthenticatable

  # Require API key authentication
  before_action :authenticate_with_api_key, only: %i[update]
	before_action :set_franchise, only: [:update]

	def update
		fp = franchise_params

		@franchise.assign_attributes(fp)

		set_dates(fp)

		@franchise.save!

		render json: @franchise


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

  def set_dates(fp)
    @franchise.start_date = Date.strptime(fp[:start_date],I18n.translate('date.formats.default')) unless fp[:start_date].blank?
    @franchise.renew_date = Date.strptime(fp[:renew_date],I18n.translate('date.formats.default')) unless fp[:renew_date].blank?
    @franchise.term_date = Date.strptime(fp[:term_date], I18n.translate('date.formats.default')) unless fp[:term_date].blank?
  end

end