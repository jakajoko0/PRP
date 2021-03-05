class Admins::RemittancesController < ApplicationController
before_action :set_remittance, only: [:audit, :edit, :update, :destroy, :show]


def index
  #Compute proper year and month to show
  @pending = Remittance.all_recent_pending
  @posted = Remittance.all_recent_posted
  
  authorize! :read, Remittance
end

def new 
  #Make sure a Franchise was selected
  redirect_to root_url, notice: I18n.t('franchise_not_selected') unless params[:franchise_id]
  franchise_id = params[:franchise_id].to_i
  #Grab history, rebates and royalty rate, admin flag
  gon.previous = Remittance.get_history(franchise_id)
	gon.rebates = Franchise.rebates(franchise_id)
  gon.admin = true
  gon.royalty_rate = Remittance::ROYALTY_RATE

  #Compute year and month (defaults to last month)
  the_year = Date.today.year 
  
  if Date.today.month == 1
    the_month = 12
    the_year = the_year-1 
  else
    the_month = Date.today.month-1
  end
  #Create the new Remittance object with defaults
  @remittance = Remittance.new(franchise_id: franchise_id,
                              month: the_month,
                              year: the_year,
                              date_received: DateTime.now,
                              date_posted: DateTime.now,
                              status: :pending)
  #Make sure users can create a new remittance
  authorize! :new, @remittance
end

def create
  #Make sure users can create a new remittance
  authorize! :create, Remittance
  #Make sure a Franchise was selected
  fran = remittance_params[:franchise_id].to_i 
  current_franchise = Franchise.find(fran)
  #Grab history, rebates and royalty rate
  gon.previous = Remittance.get_history(current_franchise.id)
  gon.rebates = Franchise.rebates(current_franchise.id)
  gon.admin = true
  gon.royalty_rate = Remittance::ROYALTY_RATE

  #Call the CreateRemittance interactor
  result = CreateRemittance.call(params: remittance_params, user: current_authenticated, admin: true, submit_type: submit_type)

  if result.success?
  	flash[:success] = I18n.t('remittance.create.confirm')
  	redirect_to admins_remittances_path
  else
    @remittance = result.remittance
  	render action: :new 
  end
end

def edit
  #Make sure user can edit remittance
	authorize! :edit, @remittance
  #Grab history, rebates and royalty rate
  gon.previous = Remittance.get_history(@remittance.franchise_id)
  gon.rebates = Franchise.rebates(@remittance.franchise_id)
  gon.admin = true
  gon.royalty_rate = Remittance::ROYALTY_RATE
  
end

def update
  #Make sure the user can update a remittance
  authorize! :update, @remittance
  #Grab history, rebates and royalty rate
  gon.previous = Remittance.get_history(@remittance.franchise_id)
  gon.rebates = Franchise.rebates(@remittance.franchise_id)
  gon.admin = true
  gon.royalty_rate = Remittance::ROYALTY_RATE  

  #Call the UpdateRemittance Interactor
  result = UpdateRemittance.call(remittance: @remittance,
                           params: remittance_params,
                           user: current_authenticated,
                           admin: true,
                           submit_type: submit_type)
	
	if result.success?
		flash[:success] = I18n.t('remittance.update.confirm')
		redirect_to admins_remittances_path 
	else
    @remittance = result.remittance
		render 'edit'
	end
end

def destroy 
  #Make sure the user can destroy a remittance
  authorize! :destroy, @remittance
  if @remittance.destroy
    flash[:success] = I18n.t('remittance.delete.confirm')
    redirect_to admins_remittances_path 
  else
    flash[:danger] = @remittances.errors.full_messages.to_sentence
    redirect_to admins_remittances_path
  end
end

def show 
end

def audit
  @audits = @remittance.audits.descending
end

private
	def set_remittance
		@remittance = Remittance.friendly.find(params[:id])
  end

  def remittance_params
     params.require(:remittance).permit(Remittance.column_names - ["created_at", "updated_at"])
  end

  def submit_type
    params[:submit]
  end


end