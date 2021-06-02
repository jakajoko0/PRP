class FranchiseDirectoryController < ApplicationController
  def index
    if !params[:lastname].blank? || !params[:firstname].blank? || !params[:state].blank?
      @franchises = Franchise.directory(params[:lastname], params[:firstname], params[:state])
    else
      @franchises = []
    end
  end 
    
  

end


