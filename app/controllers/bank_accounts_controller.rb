# frozen_string_literal: true

# For User to List, Add, Edit, Delete Bank Accounts
class BankAccountsController < ApplicationController
  before_action :set_bank_account, only: %i[edit destroy update]

  def index
    @bank_accounts = current_user.franchise.bank_accounts.order(:id)
    authorize! :read, BankAccount
  end

  def new
    @bank_account = current_user.franchise.bank_accounts.new
    authorize! :new, @bank_account
  end

  def create
    authorize! :create, BankAccount
    result = CreateBankAccount.call(params: bank_account_params, user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('bank_account.create.confirm')
      redirect_to bank_accounts_path
    else
      @bank_account = result.bank_account
      render action: :new
    end
  end

  def edit
    authorize! :edit, @bank_account
    result = RetrieveBankAccount.call(account: @bank_account, user: current_authenticated)
    @bank_account = result.bank_account
  end

  def update
    authorize! :update, @bank_account
    result = UpdateBankAccount.call(account: @bank_account, params: bank_account_params, user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('bank_account.update.confirm')
      redirect_to bank_accounts_path
    else
      @bank_account = result.bank_account
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @bank_account
    if @bank_account.destroy
      flash[:success] = I18n.t('bank_account.delete.confirm')
    else
      flash[:danger] = @bank_account.errors.full_messages.to_sentence
    end
    redirect_to bank_accounts_path
  end

  private

  def set_bank_account
    @bank_account = BankAccount.friendly.find(params[:id])
  end

  def bank_account_params
    params.require(:bank_account)
          .permit(:franchise_id, :routing, :account_number,
                  :name_on_account, :type_of_account, :bank_name)
  end
end
