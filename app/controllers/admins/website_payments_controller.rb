# frozen_string_literal: true

# For Admins to List, Add, Edit, Delete WebsitePreferences
class Admins::WebsitePaymentsController < ApplicationController

  def index
    return redirect_to website_payment_list_path if !params.has_key?(:month) && !params.has_key?(:year)   
    @yr = params[:year].to_i 
    @mo = params[:month].to_i
    @payments = WebsitePayment.all_payments_for(@yr,@mo)
  end 
end
