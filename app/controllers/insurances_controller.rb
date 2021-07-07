# frozen_string_literal: true

# For User to List, Add, Edit, Delete Web Preferences
class InsurancesController < ApplicationController
  
  def show
    @insurance = Insurance.find(params[:id])
  end

   
end
