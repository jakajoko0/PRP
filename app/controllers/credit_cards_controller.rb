class CreditCardsController < ApplicationController
	before_action :set_credit_card, only: [:edit, :destroy, :update]
	before_action :set_years, only: [:edit, :update, :new, :create]

	

	def index 
		@credit_cards = current_user.franchise.credit_cards.order(:id)
		authorize! :read, CreditCard
	end

	def new 
		@credit_card = current_user.franchise.credit_cards.new()
		authorize! :new, @credit_card
	end

	def create
		authorize! :create, CreditCard
		result = CreateCreditCard.call(params: credit_card_params, user: current_authenticated)
		if result.success?
			flash[:success] = I18n.t('credit_card.create.confirm')
			redirect_to credit_cards_path
		else
			@credit_card = result.credit_card
			render action: :new
		end
	end

	def edit
		authorize! :edit, @credit_card
		result = RetrieveCreditCard.call(account: @credit_card, user: current_authenticated)
		@credit_card = result.credit_card
	end

	def update 
		authorize! :update, @credit_card
		@credit_card.assign_attributes(credit_card_params)
		result = UpdateCreditCard.call(account: @credit_card, params: credit_card_params, user: current_authenticated)
		if result.success?
			flash[:success] = I18n.t('credit_card.update.confirm')
			redirect_to credit_cards_path
		else
			@credit_card = result.credit_card
			render 'edit'
		end
	end

	def destroy
		authorize! :destroy, @credit_card
		if @credit_card.destroy
			flash[:success] = I18n.t('credit_card.delete.confirm')
			redirect_to credit_cards_path 
		else
			flash[:danger] = I18n.t('credit_card.delete.error')
			render 'index'
		end
	end



  private 

  def set_credit_card
  	@credit_card = CreditCard.friendly.find(params[:id])
  end

  def set_years
  	d = Date.today
  	@years = (d.strftime("%y")..d.next_year(10).strftime("%y")).to_a
  end

  def credit_card_params
  	params.require(:credit_card)
  	.permit(:franchise_id, :cc_type, :cc_number,
		:cc_exp_month, :cc_exp_year, :cc_name, :cc_address,
		:cc_city, :cc_state, :cc_zip)   
	end

end