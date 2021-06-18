# frozen_string_literal: true

# For Admins to Manage Pending Check Payments
class Admins::CheckPaymentsController < ApplicationController
	before_action :set_check_payment, only: %i[audit edit show update destroy]

	
	def index
		@pending_checks = CheckPayment.all_pending
	end

	def new
		return redirect_to root_url, notice: I18n.t('franchise_not_selected') unless params[:franchise_id]
    @franchise = Franchise.find(params[:franchise_id].to_i)
    @check_payment = @franchise.check_payments.new

    authorize! :new, @check_payment
	end

	def create
		authorize! :create, CheckPayment

		result = CreateCheckPayment.call(params: check_payment_params, user: current_authenticated)

		if result.success?
			flash[:success] = I18n.t('payment.create.confirm')
			redirect_to admins_receipts_path
		else
			@check_payment = result.check_payment 
			render action: new
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
      redirect_to admins_receipts_path
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
		redirect_to admins_receipts_path
	end


	private

	def check_payment_params
		params.require(:check_payment)
		.permit(:franchise_id, :amount, :check_number, :date_approved, :date_entered, :status, :note )
	end


	def set_check_payment
		@check_payment = CheckPayment.find(params[:id])
	end

end