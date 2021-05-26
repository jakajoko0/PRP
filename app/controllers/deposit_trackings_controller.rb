# frozen_string_literal: true

# For User to List, Add, Edit, Delete Deposits
class DepositTrackingsController < ApplicationController
  before_action :set_deposit, only: %i[edit update destroy]
  before_action :set_period, only: %i[index]

  def index
    @deposits = DepositTracking.for_current_month(current_user.franchise_id, @year, @month)
    @sums = DepositTracking.get_sum_by_category(current_user.franchise_id, @year, @month)

    authorize! :read, DepositTracking
  end

  def new
    @deposit = current_user.franchise.deposit_trackings.new(deposit_date: Date.today)
    authorize! :new, @deposit
  end

  def create
    authorize! :create, DepositTracking

    result = CreateDepositTracker.call(params: deposit_params, user: current_authenticated)

    if result.success?
      flash[:success] = I18n.t('deposit_tracking.create.confirm')
      redirect_to deposit_trackings_path
    else
      @deposit = result.deposit_tracking
      render action: :new
    end
  end

  def edit
    authorize! :edit, @deposit
  end

  def update
    authorize! :update, @deposit
    result = UpdateDepositTracker.call(deposit_tracking: @deposit,
                                       params: deposit_params,
                                       user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('deposit_tracking.update.confirm')
      redirect_to deposit_trackings_path
    else
      @deposit = result.deposit_tracking
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @deposit
    if @deposit.destroy
      flash[:success] = I18n.t('deposit_tracking.delete.confirm')
    else
      flash[:danger] = @deposit.errors.full_messages.to_sentence
    end
    redirect_to deposit_trackings_path
  end

  private

  def deposit_params
    params.require(:deposit_tracking).permit(DepositTracking.column_names - %w[created_at updated_at])
  end

  def set_deposit
    @deposit = DepositTracking.friendly.find(params[:id])
  end

  def set_period
    if params[:target_month] && params[:target_year]
      @month = params[:target_month].to_i
      @year = params[:target_year].to_i
    else
      @month = Date.today.month
      @year = Date.today.year
    end
  end
end
