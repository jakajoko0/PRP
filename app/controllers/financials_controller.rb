# frozen_string_literal: true

# For User to List, Add, Edit, Delete Financial Reports
class FinancialsController < ApplicationController
  before_action :set_financial, only: %i[edit update show destroy]
  before_action :set_gon, only: %i[new create edit update]

  def index
    @financials = Financial.for_franchise(current_user.franchise_id)
    authorize! :read, Financial
  end

  def new
    @financial = current_user.franchise.financials.new
    authorize! :new, @financial
  end

  def create
    authorize! :create, Financial
    result = CreateFinancial.call(params: financial_params, user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('financial.create.confirm')
      redirect_to financials_path
    else
      @financial = result.financial
      render action: :new
    end
  end

  def edit
    authorize! :edit, @financial
    gon.previous = Financial.get_history(@financial.franchise_id)
  end

  def update
    authorize! :update, @financial
    result = UpdateFinancial.call(financial: @financial, params: financial_params, user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('financial.update.confirm')
      redirect_to financials_path
    else
      @financial = result.financial
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @financial
    if @financial.destroy
      flash[:success] = I18n.t('financial.delete.confirm')
    else
      flash[:danger] = @financial.errors.full_messages.to_sentence
    end
    redirect_to financials_path
  end

  private

  def financial_params
    params.require(:financial).permit(Financial.column_names - %w[created_at updated_at])
  end

  def set_financial
    @financial = Financial.friendly.find(params[:id])
  end

  def set_gon
    gon.previous = Financial.get_history(current_user.franchise_id)
  end
end
