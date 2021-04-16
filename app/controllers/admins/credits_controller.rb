# frozen_string_literal: true

# For Admins to List, Add, Edit, Delete Credits
class Admins::CreditsController < ApplicationController
  before_action :set_credit, only: %i[audit edit update destroy]

  def index
    @credits = PrpTransaction.all_credits
                             .paginate(per_page: 10, page: params[:page])
    authorize! :read, PrpTransaction
  end

  def new
    redirect_to root_url, notice: I18n.t('franchise_not_selected') unless params[:franchise_id]
    franchise_id = params[:franchise_id].to_i
    @credit = PrpTransaction.new(franchise_id: franchise_id,
                                 trans_type: 2,
                                 date_posted: DateTime.now)

    authorize! :new, @credit
  end

  def create
    authorize! :create, PrpTransaction
    result = CreateCredit.call(params: credit_params,
                               user: current_authenticated)

    if result.success?
      flash[:success] = I18n.t('credit.create.confirm')
      redirect_to admins_credits_path
    else
      @credit = result.credit
      render action: :new
    end
  end

  def edit
    authorize! :edit, @credit
  end

  def update
    authorize! :update, @credit
    result = UpdateCredit.call(credit: @credit,
                               params: credit_params,
                               user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('credit.update.confirm')
      redirect_to admins_credits_path
    else
      @credit = result.credit
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @credit
    if @credit.destroy
      flash[:success] = I18n.t('credit.delete.confirm')
    else
      flash[:error] = @credit.errors.full_messages.to_sentence
    end
    redirect_to admins_credits_path
  end

  def audit
    @audits = @credit.audits.descending
  end

  private

  def set_credit
    @credit = PrpTransaction.find(params[:id])
  end

  def credit_params
    params.require(:prp_transaction)
          .permit(:franchise_id, :date_posted, :trans_type,
                  :trans_code, :trans_description, :amount)
  end
end
