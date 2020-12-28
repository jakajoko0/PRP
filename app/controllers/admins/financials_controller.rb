class Admins::FinancialsController < ApplicationController
before_action :set_financial, only: [:audit, :edit, :update, :destroy]


def index
  @financials = Financial.all_ordered
  authorize! :read, Financial
end

def new 
  redirect_to root_url, notice: I18n.t('franchise_not_selected') unless params[:franchise_id]
  franchise_id = params[:franchise_id].to_i
	@financial = Financial.new(franchise_id: franchise_id)

	authorize! :new, @financial
end

def create
  authorize! :create, Financial
  fran = financial_params[:franchise_id].to_i 
  current_franchise = Franchise.find(fran)
  gon.previous = Financial.get_history(current_franchise.id)
  result = CreateFinancial.call(params: financial_params, user: current_authenticated)

  if result.success?
  	flash[:success] = I18n.t('financial.create.confirm')
  	redirect_to admins_financials_path
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
  result = UpdateFinancial.call(financial: @financial,
                           params: financial_params,
                           user: current_authenticated
                           )
	
	if result.success?
		flash[:success] = I18n.t('financial.update.confirm')
		redirect_to admins_financials_path 
	else
    @financial = result.financial
		render 'edit'
	end
end

def destroy 
  authorize! :destroy, @financial
    if @financial.destroy
      flash[:success] = I18n.t('financial.delete.confirm')
      redirect_to admins_financials_path 
    else
      flash[:danger] = @financial.errors.full_messages.to_sentence
      redirect_to admins_financials_path
    end
end

def show 
end

def audit
  @audits = @financial.audits.descending
end

private
	def set_financial
		@financial = Financial.friendly.find(params[:id])
  end


  def financial_params
     params.require(:financial).permit(Financial.column_names - ["created_at", "updated_at"])
  end


end