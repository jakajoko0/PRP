class ApplicationController < ActionController::Base
  before_action :pass_locale_js
  before_action :prepare_exception_notifier
  before_action :configure_permitted_params, if: :devise_controller?
  around_action :set_time_zone, if: :current_authenticated
  rescue_from CanCan::AccessDenied,with: :access_error 
  
  def current_ability
    @current_ability ||= current_admin ? AdminAbility.new(current_admin) : UserAbility.new(current_user)  
  end

  def current_authenticated
    if current_user 
      current_user 
    elsif current_admin
      current_admin
    else
      nil
    end
  end
    

  protected 
    
  def configure_permitted_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:email,:password, :current_password, :time_zone])
  end

  private
  #Make sure we add the current user information when an
  #Exception happens
  def access_error(exception)
    flash[:warning] = exception.message
    redirect_to root_path
  end

  def prepare_exception_notifier
    if current_user
      request.env["exception_notifier.exception_data"] = 
      {current_user: current_user }
    end 

    if current_admin
      request.env["exception_notifier.exception_data"] = 
      {current_admin: current_admin}
    end
  end
  
  #Pass that locale to our js
  def pass_locale_js
    gon.I18n = I18n.locale
  end 

  #Set the locale for the entire app
  def set_time_zone(&block)
    Time.use_zone(current_authenticated.time_zone, &block)
  end
end
