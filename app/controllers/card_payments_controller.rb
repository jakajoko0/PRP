# frozen_string_literal: true

# For User to List, Add, Edit, Delete Bank Payments
class CardPaymentsController < ApplicationController
	before_action :set_card_payment, only: %i[show]
	before_action :find_balance, only: %i[new create]
	before_action :populate_tokens, only: %i[new create]
	
	def new
		@card_payment = current_user.franchise.card_payments.new
		if params[:invoice_id]
			process_invoice_payment
		end
		authorize! :new, @card_payment
	end

	def create
		authorize! :create, CardPayment

		result = CreateCardPayment.call(params: card_payment_params.merge(status: "pending", date_entered: DateTime.now, note: "Processing"),
			                              user: current_authenticated)

		if result.success?
			flash[:success] = I18n.t('payment.create.confirm')
			redirect_to payments_path
		else
			@card_payment = result.card_payment 
			render action: :new
	  end

	end

	private

	def card_payment_params
		params.require(:card_payment)
		.permit(:franchise_id, :amount, :gms_token, :invoice_payment, :invoice_id)
	end

	def populate_tokens
    # Populate the array of bank accounts for the dropdown list
    @tokens = []
    cards = current_user.franchise.credit_cards.order("id")
    @tokens = cards.map{|c| [c.card_type_and_number, c.card_token]}
	end

	def find_balance
    @balance = FranchisesQuery.new.get_royalty_balance(current_user.franchise_id)
	end

	def set_bank_payment
		@card_payment = CardPayment.find(params[:id])
	end

	def process_invoice_payment
    @target_invoice = Invoice.find(params[:invoice_id])
    @card_payment.invoice_payment = 1
    @card_payment.invoice_id = params[:invoice_id]
    @card_payment.amount = @target_invoice.invoice_total
	end

end