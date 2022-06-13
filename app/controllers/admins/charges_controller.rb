# frozen_string_literal: true

# For Admins to List, Add, Edit, Delete Charges
class Admins::ChargesController < ApplicationController
  before_action :set_charge, only: %i[audit edit update destroy show]

  def index
    @charges = PrpTransaction.all_charges
                             .paginate(per_page: 10, page: params[:page])

    authorize! :read, PrpTransaction
  end

  def new
    redirect_to root_url, notice: I18n.t('franchise_not_selected') unless params[:franchise_id]
    franchise_id = params[:franchise_id].to_i
    @charge = PrpTransaction.new(franchise_id: franchise_id,
                                 trans_type: 1,
                                 date_posted: DateTime.now)

    authorize! :new, @charge
  end

  def create
    authorize! :create, PrpTransaction
    result = CreateCharge.call(params: charge_params, user: current_authenticated)

    if result.success?
      flash[:success] = I18n.t('charge.create.confirm')
      redirect_to admins_charges_path
    else
      @charge = result.charge
      render action: :new
    end
  end

  def edit
    authorize! :edit, @charge
  end

  def show
  end

  def update
    authorize! :update, @charge
    result = UpdateCharge.call(charge: @charge,
                               params: charge_params,
                               user: current_authenticated)

    if result.success?
      flash[:success] = I18n.t('charge.update.confirm')
      redirect_to admins_charges_path
    else
      @charge = result.charge
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @charge
    if @charge.destroy
      flash[:success] = I18n.t('charge.delete.confirm')
    else
      flash[:error] = @charge.errors.full_messages.to_sentence
    end
    redirect_to admins_charges_path
  end

  def audit
    @audits = @charge.audits.descending
  end

  private

  def set_charge
    @charge = PrpTransaction.find(params[:id])
  end

  def charge_params
    params.require(:prp_transaction)
          .permit(:franchise_id, :date_posted, :trans_type,
                  :trans_code, :trans_description, :amount)
  end
end
