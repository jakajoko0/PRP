# frozen_string_literal: true

# For Admins to List, Add, Edit, Delete Financial Reports
class Admins::FinancialsController < ApplicationController
  before_action :set_financial, only: %i[audit edit update destroy show]
  before_action :set_franchise, only: %i[create]

  def index
    @financials = Financial.all_ordered
    authorize! :read, Financial
  end

  def new
    redirect_to root_url, notice: I18n.t('franchise_not_selected') unless params[:franchise_id]
    franchise_id = params[:franchise_id].to_i
    @financial = Financial.new(franchise_id: franchise_id)
    authorize! :new, @financial
  end

  def create
    authorize! :create, Financial
    prepare_gon(@franchise.id)
    result = CreateFinancial.call(params: financial_params, user: current_authenticated)

    if result.success?
      flash[:success] = I18n.t('financial.create.confirm')
      redirect_to admins_financials_path
    else
      @financial = result.financial
      render action: :new
    end
  end

  def edit
    authorize! :edit, @financial
    prepare_gon(@financial.franchise_id)
  end

  def update
    prepare_gon(@financial.franchise_id)
    authorize! :update, @financial
    result = UpdateFinancial.call(financial: @financial,
                                  params: financial_params,
                                  user: current_authenticated)

    if result.success?
      flash[:success] = I18n.t('financial.update.confirm')
      redirect_to admins_financials_path
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
    redirect_to admins_financials_path
  end

  def show; end

  def audit
    @audits = @financial.audits.descending
  end

  private

  def set_financial
    @financial = Financial.friendly.find(params[:id])
  end

  def set_franchise
    @franchise = Franchise.find(financial_params[:franchise_id].to_i)
  end

  def financial_params
    params.require(:financial).permit(Financial.column_names - %w[created_at updated_at])
  end

  def prepare_gon(franchise_id)
    gon.previous = Financial.get_history(franchise_id)
  end
end
