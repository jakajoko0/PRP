class Admins::InsurancesController < ApplicationController
helper_method :sort_column, :sort_direction
before_action :set_insurance, only: [:edit, :update]


def index
  logger.debug("Params Search: #{params[:search]}")
	@insurances = Insurance.search(params[:search])
	               .order(sort_column + " " + sort_direction)
                 .paginate(per_page: 10, page: params[:page])
  
  authorize! :read, Insurance
end

def new 
  redirect_to root_url, notice: 'A Franchise was Not Selected' unless params[:franchise_id]
  franchise_id = params[:franchise_id].to_i
	@insurance = Insurance.new(franchise_id: franchise_id)

	authorize! :new, @insurance
end

def create
	@insurance = new_insurance
	@insurance.set_dates(insurance_params[:eo_expiration],
                        insurance_params[:gen_expiration],
                        insurance_params[:other_expiration])

	authorize! :create, @insurance
  if @insurance.save 
  	flash[:success] = "Insurance Record Created Successfully"
  	redirect_to admins_insurances_path
  else
  	render action: :new 
  end
end

def edit
	authorize! :edit, @insurance
end

def update
	authorize! :update, @insurance
	@insurance.assign_attributes(insurance_params)
	@insurance.set_dates(insurance_params[:eo_expiration],
                        insurance_params[:gen_expiration],
		                    insurance_params[:other_expiration])
	if @insurance.save 
		flash[:success] = "Insurance Record Modified Successfully"
		redirect_to admins_insurances_path 
	else
		render 'edit'
	end
end

def destroy 
end

def show 
	authorize! :read, @accountant
end

private
	def set_insurance
		@insurance = Insurance.friendly.find(params[:id])
  end

  def new_insurance
  	Insurance.new(insurance_params)
  end

  def insurance_params
    params.require(:insurance)
    .permit(:franchise_id, :eo_insurance, :gen_insurance,
    :other_insurance, :other_description, :eo_expiration, :gen_expiration,
    :other_expiration)
  end

  def sort_column
    params[:sort] ? params[:sort] : 'franchises.franchise_number'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

end