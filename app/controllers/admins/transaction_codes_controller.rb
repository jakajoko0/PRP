# frozen_string_literal: true

# For Admins to List, Add, Edit, Delete Transaction Codes
class Admins::TransactionCodesController < ApplicationController
  before_action :set_trans_code, only: %i[edit update]

  def index
    @transaction_codes = TransactionCode.by_code
    authorize! :read, TransactionCode
  end

  def new
    @trans_code = TransactionCode.new(show_in_royalties: false,
                                      show_in_invoicing: false)
    authorize! :new, @trans_code
  end

  def create
    authorize! :create, TransactionCode
    result = CreateTransactionCode.call(params: trans_code_params,
                                        user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('transaction_code.create.confirm')
      redirect_to admins_transaction_codes_path
    else
      @trans_code = result.trans_code
      render action: :new
    end
  end

  def edit
    authorize! :edit, @trans_code
  end

  def update
    authorize! :update, @trans_code
    result = UpdateTransactionCode.call(trans_code: @trans_code,
                                        params: trans_code_params,
                                        user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('transaction_code.update.confirm')
      redirect_to admins_transaction_codes_path
    else
      @trans_code = result.trans_code
      render action: :edit
    end
  end

  private

  def set_trans_code
    @trans_code = TransactionCode.find(params[:id])
  end

  def trans_code_params
    params.require(:transaction_code)
          .permit(:code, :description, :trans_type,
                  :show_in_royalties, :show_in_invoicing)
  end
end
