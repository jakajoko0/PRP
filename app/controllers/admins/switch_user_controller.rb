class Admins::SwitchUserController < ApplicationController


def index
  @user_list = User.filter_user(params[:search])
end
 

end