class Admins::AdminsController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  
  def index
	  @admin_users = Admin.all

	  authorize! :read, Admin
  end

  def new
  	@admin = Admin.new
  	authorize! :new, @admin
  end


  def create
  	authorize! :create, Admin

  	result = CreateAdmin.call(params: admin_params, user: current_authenticated)
    
    if result.success?
    	
      flash[:success] = "Admin user created successfully"
      redirect_to admins_admins_path
    else
      @admin = result.admin
      render action: :new
    end  	
  end

  def edit
  	authorize! :edit, @admin
  end

  def update
  	authorize! :update, @admin
  	result = UpdateAdmin.call(admin: @admin,
  		                        params: admin_params,
  		                        user: current_authenticated)
  	if result.success?
  		flash[:success] = "Admin user updated successfully"
  		redirect_to admins_admins_path
  	else
  		@admin = result.admin 
  		render 'edit'
  	end
  end

  def destroy
  	authorize! :destroy, @admin
  	if @admin.destroy
      flash[:success] = "Admin user deleted succeessfully"
    else
      flash[:danger] = @admin.errors.full_messages.to_sentence
    end
    redirect_to admins_admins_path
  end


  private

  def set_user
  	@admin = Admin.find(params[:id])
  end

  def admin_params
  	params.require(:admin)
  	.permit(:email, :role)
  end

end