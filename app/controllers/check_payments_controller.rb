# frozen_string_literal: true

# For User to List, Add, Edit, Delete Check Payments
class CheckPaymentsController < ApplicationController
	before_action :set_check_payment, only: %i[edit show update destroy]
	before_action :find_balance, only: %i[new create edit update]
	
	def new
		@check_payment = current_user.franchise.check_payments.new
		if params[:invoice_id]
			process_invoice_payment
		end
		authorize! :new, @check_payment
	end

	def create
		authorize! :create, CheckPayment

		result = CreateCheckPayment.call(params: check_payment_params.merge(status: "pending", date_entered: DateTime.now, payment_date: DateTime.now),
		user: current_authenticated)

		if result.success?
			flash[:success] = I18n.t('payment.create.confirm')
			redirect_to payments_path
		else
			@check_payment = result.check_payment 
			render action: :new
	  end

	end

	def edit
		authorize! :edit, @check_payment
	end

	def update
		authorize! :update, @check_payment
    result = UpdateCheckPayment.call(check_payment: @check_payment,
                                       params: check_payment_params,
                                       user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('payment.update.confirm')
      redirect_to payments_path
    else
      @check_payment = result.check_payment
      render 'edit'
    end
	end

	def destroy
		authorize! :destroy, @check_payment
		result = DeleteCheckPayment.call(check_payment: @check_payment)
		if result.success?
			flash[:success] = I18n.t('payment.delete.confirm')
		else
			@check_payment = result.check_payment
			flash[:danger] = @check_payment.errors.full_messages.to_sentence
    end
		redirect_to payments_path
	end


	private

	def check_payment_params
		params.require(:check_payment)
		.permit(:franchise_id, :amount, :check_number,
		        :invoice_payment, :invoice_id )
	end


	def find_balance
    @balance = FranchisesQuery.new.get_royalty_balance(current_user.franchise_id)
	end

	def set_check_payment
		@check_payment = CheckPayment.find(params[:id])
	end

	def process_invoice_payment
    @target_invoice = Invoice.find(params[:invoice_id])
    @check_payment.invoice_payment = 1
    @check_payment.invoice_id = params[:invoice_id]
    @check_payment.amount = @target_invoice.invoice_total
	end

end