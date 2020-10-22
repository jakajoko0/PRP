class FranchisesController < ApplicationController
  before_action :set_franchise, only: [:edit, :update]


  def edit
    authorize! :edit, @franchise
  end

  def update
    authorize! :update, @franchise
    result = UpdateFranchise.call(franchise: @franchise, params: franchise_params, user: current_authenticated)

    if result.success?
      flash[:success] = "Franchise profile modified successfully"
      redirect_to root_path
    else
      @franchise = result.franchise
      render 'edit'
    end

  end


  private

  #Franchise Users can only modify the advanced rebate field
  def franchise_params
    params.require(:franchise)
    .permit(:lastname, :firstname, :initial, :salutation,
      :address, :address2, :city, :state, :zip_code,
      :ship_address, :ship_address2, :ship_city, :ship_state, :ship_zip_code,
      :home_address, :home_address2, :home_city, :home_state, :home_zip_code,
      :phone, :phone2, :mobile, :fax, :email, :alt_email, :advanced_rebate  )
  end
  
  

  #Set the franchise instance variable for use in different methods
  def set_franchise
  	@franchise = Franchise.friendly.find(params[:id])
  end

end