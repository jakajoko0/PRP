# frozen_string_literal: true

# For User to List, Add, Edit, Delete Bank Payments
class BankPaymentsController < ApplicationController
	before_action :set_bank_payment, only: %i[edit show update destroy]
	before_action :find_balance, only: %i[new create edit update]
	before_action :populate_tokens, only: %i[new create edit update]
	
	def new
		@bank_payment = current_user.franchise.bank_payments.new
		if params[:invoice_id]
			process_invoice_payment
		end
		authorize! :new, @bank_payment
	end

	def create
		authorize! :create, BankPayment

		result = CreateBankPayment.call(params: bank_payment_params.merge(status: "pending", date_entered: DateTime.now, note: "Awaiting Transfer"), user: current_authenticated)

		if result.success?
			flash[:success] = I18n.t('payment.create.confirm')
			redirect_to payments_path
		else
			@bank_payment = result.bank_payment 
			render action: :new
	  end

	end

	def edit
		authorize! :edit, @bank_payment
	end

	def update
		authorize! :update, @bank_payment
    result = UpdateBankPayment.call(bank_payment: @bank_payment,
                                       params: bank_payment_params,
                                       user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('payment.update.confirm')
      redirect_to payments_path
    else
      @bank_payment = result.bank_payment
      render 'edit'
    end
	end

	def destroy
		authorize! :destroy, @bank_payment
		result = DeleteBankPayment.call(bank_payment: @bank_payment)
		if result.success?
			flash[:success] = I18n.t('payment.delete.confirm')
		else
			@bank_payment = result.bank_payment
			flash[:danger] = @bank_payment.errors.full_messages.to_sentence
    end
		redirect_to payments_path
	end


	private

	def bank_payment_params
		params.require(:bank_payment)
		.permit(:franchise_id, :amount,
			      :gms_token, :payment_date,
			      :invoice_payment, :invoice_id)
	end

	def populate_tokens
    # Populate the array of bank accounts for the dropdown list
    @tokens = []
    banks = current_user.franchise.bank_accounts.order("id")
    @tokens = banks.map{|b| [b.bank_name_and_number, b.bank_token]}
	end

	def find_balance
    @balance = FranchisesQuery.new.get_royalty_balance(current_user.franchise_id)
	end

	def set_bank_payment
		@bank_payment = BankPayment.find(params[:id])
	end

	def process_invoice_payment
    @target_invoice = Invoice.find(params[:invoice_id])
    @bank_payment.invoice_payment = 1
    @bank_payment.invoice_id = params[:invoice_id]
    @bank_payment.amount = @target_invoice.invoice_total
	end

end