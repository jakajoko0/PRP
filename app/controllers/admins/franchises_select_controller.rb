# frozen_string_literal: true

# For Admins to Select a Franhcise for further operation
class Admins::FranchisesSelectController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @destination = params[:destination]
    # Pass the destination to javascript
    gon.destination = @destination
    @franchises = Franchise.search(params[:search])
                           .order("#{sort_column} #{sort_direction}")
                           .paginate(per_page: 20, page: params[:page])
    authorize! :read, Franchise
  end

  private

  def sort_column
    Franchise.column_names.include?(params[:sort]) ? params[:sort] : 'franchise_number'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
