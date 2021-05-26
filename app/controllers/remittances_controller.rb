# frozen_string_literal: true

# For Users to List, Add, Edit, Delete Remittances
class RemittancesController < ApplicationController
  before_action :set_remittance, only: %i[edit update show destroy]
  before_action :set_period, only: %i[index new]

  def index
    @pending = current_user.franchise.remittances.recent_pending
    @posted = current_user.franchise.remittances.recent_posted
    authorize! :read, Remittance
  end

  def new
    # Grab history, rebates, royalty rates and admin flag
    prepare_gon(current_user.franchise_id)
    result = NewRemittance.call(current_user: current_user, year: @year, month: @month)

    if result.success?
      @remittance = result.remittance
    else
      flash[:danger] = 'Could not create new remittance'
      redirect_to remittances_path
    end

    authorize! :new, @remittance
  end

  def create
    authorize! :create, Remittance
    prepare_gon(current_user.franchise_id)
    result = CreateRemittance.call(params: remittance_params, admin: false, submit_type: submit_type,
                                   user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('remittance.create.confirm')
      redirect_to remittances_path
    else
      @remittance = result.remittance
      render action: :new
    end
  end

  def edit
    authorize! :edit, @remittance
    prepare_gon(@remittance.franchise_id)
  end

  def update
    authorize! :update, @remittance

    # Grab history, rebates and royalty rate
    prepare_gon(@remittance.franchise_id)

    result = UpdateRemittance.call(remittance: @remittance,
                                   params: remittance_params,
                                   user: current_authenticated,
                                   admin: false,
                                   submit_type: submit_type)
    if result.success?
      flash[:success] = I18n.t('remittance.update.confirm')
      redirect_to remittances_path
    else
      @remittance = result.remittance
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @remittance
    if @remittance.destroy
      flash[:success] = I18n.t('remittance.delete.confirm')
    else
      flash[:danger] = @remittance.errors.full_messages.to_sentence
    end
    redirect_to remittances_path
  end

  def show; end

  private

  def remittance_params
    params.require(:remittance).permit(Remittance.column_names - %w[created_at updated_at])
  end

  def set_remittance
    @remittance = Remittance.friendly.find(params[:id])
  end

  def submit_type
    params[:submit]
  end

  def prepare_gon(fran_id)
    gon.previous = Remittance.get_history(fran_id)
    gon.rebates = Franchise.rebates(fran_id)
    gon.admin = false
    gon.royalty_rate = Remittance::ROYALTY_RATE
  end

  def set_period
    if params[:target_month] && params[:target_year]
      set_from_params
    else
      set_from_date
    end
  end

  def set_from_params
    @month = params[:target_month].to_i
    @year = params[:target_year].to_i
  end

  def set_from_date
    @month = Date.today.month
    @year = Date.today.year

    if @month == 1
      @month = 12
      @year -= 1
    else
      @month -= 1
    end
  end
end
