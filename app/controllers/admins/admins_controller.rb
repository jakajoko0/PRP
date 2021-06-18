class Admins::AdminsController < ApplicationController

  def index
	  admin_users = Admin.all
  end

end