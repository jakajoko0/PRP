class FinancialsController < ApplicationController
before_action :set_financial, only: [:edit, :update, :show, :destroy]

  def index
  	@financials = Financial.for_franchise(current_user.franchise_id)
  	authorize! :read, Financial
 	end

 	def new
 		gon.previous = Financial.get_history(current_user.franchise_id)
 		@financial = current_user.franchise.financials.new()
 		authorize! :new, @financial
 	end

 	def create
 		authorize! :create, Financial
 		gon.previous = Financial.get_history(current_user.franchise_id)
 		result = CreateFinancial.call(params: financial_params, user: current_authenticated)
 		if result.success?
 			flash[:success] = I18n.t('financial.create.confirm')
 			redirect_to financials_path
 		else
 			@financial = result.financial
 			render action: :new
 		end
 	end

 	def edit
 		authorize! :edit, @financial
 		gon.previous = Financial.get_history(@financial.franchise_id)
 	end

 	def update
 		gon.previous = Financial.get_history(@financial.franchise_id)
 		authorize! :update, @financial
 		result = UpdateFinancial.call(financial: @financial, params: financial_params, user: current_authenticated)
 		if result.success?
 			flash[:success] = I18n.t('financial.update.confirm')
 			redirect_to financials_path
 		else
 			@financial = result.financial
 			render 'edit'
 		end
 	end

 	def destroy
 		authorize! :destroy, @financial
 		if @financial.destroy
 			flash[:success] = I18n.t('financial.delete.confirm')
 			redirect_to financials_path 
 		else
 			flash[:danger] = @financial.errors.full_messages.to_sentence
 			redirect_to financials_path
 		end
 	end

 	private

 	def financial_params
 		params.require(:financial).permit(Financial.column_names - ["created_at", "updated_at"])
 	end

 	def set_financial
 		@financial = Financial.friendly.find(params[:id])
 	end
end

