# frozen_string_literal: true

# For Admins to List, Add, Edit, Delete Franchises
class Admins::FranchisesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_franchise, only: %i[show edit update audit]

  def index
    @franchises = Franchise.includes(:franchise_consolidations).search(params[:search], params[:show_inactives])
                           .order("#{sort_column} #{sort_direction}")
                           .paginate(per_page: 20, page: params[:page])
    authorize! :read, Franchise
  end

  def new
    @franchise = Franchise.new(area: 1, mast: 0)
    @franchise.franchise_consolidations.build
    authorize! :new, Franchise


  end

  def audit
    @audits = @franchise.audits.descending
  end

  def create
    authorize! :create, Franchise
    result = CreateFranchise.call(params: franchise_params, user: current_authenticated)

    if result.success?
      flash[:success] = I18n.t('franchise.create.confirm')
      redirect_to admins_franchises_path
    else
      @franchise = result.franchise
      render action: :new
    end
  end

  def edit
    @authorized_users = @franchise.users.order(:id)
    @franchise_consolidations = @franchise.franchise_consolidations
    authorize! :edit, @franchise
    
  end

  def update
    authorize! :update, @franchise
    result = UpdateFranchise.call(franchise: @franchise, params: franchise_params, user: current_authenticated)

    if result.success?
      flash[:success] = I18n.t('franchise.update.confirm')
      redirect_to admins_franchises_path
    else
      @authorized_users = @franchise.users.order(:id)
      @franchise = result.franchise
      render 'edit'
    end
  end

  def show
    authorize! :read, @franchise
  end

  private

  def sort_column
    Franchise.column_names.include?(params[:sort]) ? params[:sort] : 'franchise_number'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  # Method that finds and sets the franchiseobject needed for some actions
  def set_franchise
    @franchise = Franchise.friendly.find(params[:id])
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
                  :term_reason, :inactive,
                  franchise_consolidations_attributes: [:id, :franchise_number, :_destroy])
  end
end
