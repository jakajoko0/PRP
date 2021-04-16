# frozen_string_literal: true

# For Admins to List, Add, Edit, Delete Insurance
class Admins::InsurancesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_insurance, only: %i[audit edit update]

  def index
    @insurances = Insurance.search(params[:search])
                           .order("#{sort_column} #{sort_direction}")
                           .paginate(per_page: 10, page: params[:page])

    authorize! :read, Insurance
  end

  def new
    redirect_to root_url, notice: I18n.t('franchise_not_selected') unless params[:franchise_id]

    franchise_id = params[:franchise_id].to_i
    @insurance = Insurance.new(franchise_id: franchise_id)
    authorize! :new, @insurance
  end

  def create
    authorize! :create, Insurance
    result = CreateInsurance.call(params: insurance_params,
                                  user: current_authenticated)

    if result.success?
      flash[:success] = I18n.t('insurance.create.confirm')
      redirect_to admins_insurances_path
    else
      @insurance = result.insurance
      render action: :new
    end
  end

  def edit
    authorize! :edit, @insurance
  end

  def update
    authorize! :update, @insurance
    result = UpdateInsurance.call(insurance: @insurance,
                                  params: insurance_params,
                                  user: current_authenticated)

    if result.success?
      flash[:success] = I18n.t('insurance.update.confirm')
      redirect_to admins_insurances_path
    else
      @insurance = result.insurance
      render 'edit'
    end
  end

  def destroy; end

  def show
    authorize! :read, @insurance
  end

  def audit
    @audits = @insurance.audits.descending
  end

  private

  def set_insurance
    @insurance = Insurance.friendly.find(params[:id])
  end

  def insurance_params
    params.require(:insurance)
          .permit(:franchise_id, :eo_insurance, :gen_insurance,
                  :other_insurance, :other_description, :eo_expiration,
                  :gen_expiration, :other_expiration, :other2_insurance,
                  :other2_description, :other2_expiration)
  end

  def sort_column
    params[:sort] || 'franchises.franchise_number'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
