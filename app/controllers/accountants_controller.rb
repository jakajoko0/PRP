# frozen_string_literal: true

# For Users to List,  View,
class AccountantsController < ApplicationController
  
  before_action :set_accountant, only: %i[show]

  def index
    @accountants = current_user.franchise.accountants.by_number
    authorize! :read, Accountant
  end

    
  def show
    
  end
  

  def show
    authorize! :read, @accountant
  end

  
  private

  def set_accountant
    @accountant = Accountant.friendly.find(params[:id])
  end

  
  

 
end
