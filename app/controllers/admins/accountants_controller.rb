class Admins::AccountantsController < ApplicationController
helper_method :sort_column, :sort_direction
before_action :set_accountant, only: [:show, :edit, :update, :destroy]


def index
	@accountants = Accountant.search(params[:search])
	               .order(sort_column + " " + sort_direction)
                 .paginate(per_page: 10, page: params[:page])
  
  authorize! :read, Accountant
end

def new
  return redirect_to root_url, notice: 'A Franchise was Not Selected' unless params[:franchise_id]
  franchise_id = params[:franchise_id].to_i
	@franchise = Franchise.find(franchise_id)
  @accountant = @franchise.accountants.new

	authorize! :new, @accountant
end

def create
  authorize! :create, Accountant
  result = CreateAccountant.call(params: accountant_params, user: current_authenticated)

  if result.success?
    flash[:success] = "Accountant Created Successfully"
    redirect_to admins_accountants_path
  else
    @accountant = result.accountant
    render action: :new 
  end

	
  
end

def edit
	authorize! :edit, @accountant
end

def update
	authorize! :update, @accountant
  result = UpdateAccountant(accountant: @accountant, params: accountant_params, user: current_authenticated)
	
  if result.success?
	 flash[:success] = "Accountant Modified Successfully"
		redirect_to admins_accountants_path 
	else
    @accountant = result.accountant
		render 'edit'
	end
end

def destroy 
	authorize! :destroy, @accountant
	if @accountant.destroy
    flash[:success] = 'Accountant Deleted Successfully'
    redirect_to admins_accountants_path
  else
    flash[:error] = @accountant.errors.full_messages.to_sentence
    redirect_to admins_accountants_path
  end 

end

def show 
	authorize! :read, @accountant
end



private
	def set_accountant
		@accountant = Accountant.friendly.find(params[:id])
  end

  def new_accountant
  	Accountant.new(accountant_params)
  end

  def accountant_params
    params.require(:accountant)
     .permit(:franchise_id, :accountant_num, :lastname,
      :firstname, :initial, :salutation, :birthdate,
      :spouse_name, :spouse_birthdate, :spouse_partner,
      :start_date, :inactive, :term_date, :cpa, :mba,
      :degree, :agent, :advisory_board, :notes)
  end

  def sort_column
    Accountant.column_names.include?(params[:sort]) ? params[:sort] : 'franchises.franchise_number'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

end