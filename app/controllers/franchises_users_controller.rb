class FranchisesUsersController < ApplicationController
  before_action :set_user, only: %i[edit destroy update]
  include CustomValidations

  def create
    @user = FranchisesUser.new
    tmp_email = franchise_user_params[:email]            
    role = franchise_user_params[:role]
    fran_id = franchise_user_params[:franchise_id]
    
    
    if email_valid?(tmp_email)
  	  there = User.find_by email: tmp_email
      if there.nil?
        temp_password = SecureRandom.hex(10)
        u = User.create(email: tmp_email,
                        password: temp_password,
                        password_confirmation: temp_password,
                        franchise_id: fran_id,
                        role: role)
        u.reset_pass()
        flash[:success] = "User Created. An email was sent to #{u.email} with instructions to choose their password."
        redirect_to edit_franchise_path(id:fran_id)
      else
        flash.now[:warning]  = 'This email address has already been assigned to another user.'
        render 'new'
      end
    else
  	  flash.now[:warning] = 'Invalid email address. Please enter an email address using the proper format'
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = "User modified successfully"   
      redirect_to edit_franchise_path(id:user_params[:franchise_id].to_i)
    else
      flash[:warning] = "Problem modifying the User"   
      redirect_to edit_franchise_path(id:user_params[:franchise_id].to_i)
    end
  end

  def new
    @franchise_id = params[:franchise_id].to_i 
	  @user = FranchisesUser.new
    @user.franchise_id = @franchise_id
  end

  def destroy
    fran_id = @user.franchise_id
    if @user.destroy
      flash[:success] = "User deleted successfully"   
      redirect_to edit_franchise_path(id:fran_id)
    else
      flash[:warning] = "Problem deleting the User"   
      redirect_to edit_franchise_path(id:fran_id)
    end 
  end 

  private

  def franchise_user_params
    params.require(:franchises_user)
    .permit(:email, :role, :franchise_id)
  end

  def user_params
    params.require(:user)
    .permit(:email, :role, :franchise_id)
  end

  def set_user
    @user = User.find(params[:id])
    @franchise = params[:franchise_id]
  end
end