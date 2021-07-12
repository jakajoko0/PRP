# frozen_string_literal: true

# For Admins to List, Add, Edit, Delete Remittances
class Admins::RemittancesController < ApplicationController
  before_action :set_remittance, only: %i[audit edit update destroy show]

  def index
    @pending = Remittance.all_recent_pending
    @posted = Remittance.all_recent_posted
    authorize! :read, Remittance
  end

  def new 
    #Make sure a Franchise was selected
    redirect_to root_url, notice: I18n.t('franchise_not_selected') unless params[:franchise_id]
  
    franchise_id = params[:franchise_id].to_i
    prepare_gon(franchise_id)
    
    #Create the new Remittance object with defaults
    logger.debug "CURRENT TIME: #{Time.now}"
    @remittance = Remittance.new(franchise_id: franchise_id,
                                 month: proper_month,
                                 year: proper_year,
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
    prepare_gon(current_franchise)
    
    #Call the CreateRemittance interactor
    result = CreateRemittance.call(params: remittance_params, user: current_authenticated, 
      admin: true,
      submit_type: submit_type)

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
    prepare_gon(@remittance.franchise_id)
  end

  def update
    #Make sure the user can update a remittance
    authorize! :update, @remittance
    #Grab history, rebates and royalty rate
    prepare_gon(@remittance.franchise_id)
    

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
    else
      flash[:danger] = @remittances.errors.full_messages.to_sentence
    end
    redirect_to admins_remittances_path
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

  def proper_year
    if Date.today.month == 1
      (Date.today.year)-1 
    else
      Date.today.year 
    end
  end

  def proper_month
    Date.today.month == 1 ? 12 : Date.today.month
  end

  def prepare_gon(fran_id)
    #Grab history, rebates and royalty rate, admin flag
    gon.previous = Remittance.get_history(fran_id)
    gon.rebates = Franchise.rebates(fran_id)
    gon.admin = true
    gon.royalty_rate = Remittance::ROYALTY_RATE
  end

end