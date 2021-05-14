class RemittancesController < ApplicationController
before_action :set_remittance, only: [:edit, :update, :show, :destroy]

  def index
  	@pending = current_user.franchise.remittances.recent_pending
  	@posted = current_user.franchise.remittances.recent_posted
  	authorize! :read, Remittance
 	end

 	def new
 		#Grab history, rebates, royalty rates and admin flag
 		gon.previous = Remittance.get_history(current_user.franchise_id)
 		gon.rebates = Franchise.rebates(current_user.franchise_id)
 		gon.admin = false
 		gon.royalty_rate = Remittance::ROYALTY_RATE

 		if(params[:target_month])
 			the_month = params[:target_month].to_i
 			the_year = params[:target_year].to_i
 		else
 			if Date.today.month == 1
 				the_month = 12 
 				the_year = Date.today.year-1
 			else
 				the_month = Date.today.month-1
 				the_year = Date.today.year
 			end
 		end

 		@remittance = current_user.
 		              franchise.
 		              remittances.new(month: the_month,
 		              	             year: the_year,
 		              	             status: :pending)
 		authorize! :new, @remittance
 	end

 	def create
 		authorize! :create, Remittance
 		gon.previous = Remittance.get_history(current_user.franchise_id)
    gon.rebates = Franchise.rebates(current_user.franchise_id)
    gon.admin = true
    gon.royalty_rate = Remittance::ROYALTY_RATE
 		
 		result = CreateRemittance.call(params: remittance_params, admin: false, submit_type: submit_type, user: current_authenticated)
 		if result.success?
 			flash[:success] = I18n.t('remittance.create.confirm')
 			redirect_to remittances_path
 		else
 			@remittance = result.remittance
 			render action: :new
 		end
 	end

 	def edit
 		authorize! :edit, @remittance
 		gon.previous = Remittance.get_history(@remittance.franchise_id)
    gon.rebates = Franchise.rebates(@remittance.franchise_id)
    gon.admin = true
    gon.royalty_rate = Remittance::ROYALTY_RATE
 	end

 	def update
 		authorize! :update, @remittance
    
    #Grab history, rebates and royalty rate
    gon.previous = Remittance.get_history(@remittance.franchise_id)
    gon.rebates = Franchise.rebates(@remittance.franchise_id)
    gon.admin = true
    gon.royalty_rate = Remittance::ROYALTY_RATE   		

 		result = UpdateRemittance.call(remittance: @remittance,
 			                             params: remittance_params,
 			                             user: current_authenticated,
 			                             admin: false, 
 			                             submit_type: submit_type)
 		if result.success?
 			flash[:success] = I18n.t('remittance.update.confirm')
 			redirect_to remittances_path
 		else
 			@remittance = result.remittance
 			render 'edit'
 		end
 	end

 	def destroy
 		authorize! :destroy, @remittance
 		if @remittance.destroy
 			flash[:success] = I18n.t('remittance.delete.confirm')
 			redirect_to remittances_path 
 		else
 			flash[:danger] = @remittance.errors.full_messages.to_sentence
 			redirect_to remittances_path
 		end
 	end

 	def show
 	end


 	private

 	def remittance_params
 		params.require(:remittance).permit(Remittance.column_names - ["created_at", "updated_at"])
 	end

 	def set_remittance
 		@remittance = Remittance.friendly.find(params[:id])
 	end

 	def submit_type
 		params[:submit]
 	end
end

