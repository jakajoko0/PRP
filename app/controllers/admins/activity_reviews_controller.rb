# frozen_string_literal: true

# For User to Review their payments
class Admins::ActivityReviewsController < ApplicationController
  def index
    set_target_year

    beg_date = DateTime.new(@target_year, 1, 1)
    end_date = DateTime.new(@target_year, 12, 31)
    beg_date = beg_date.beginning_of_day
    end_date = end_date.end_of_day
    
    @trans =  PrpTransaction.by_date_range(beg_date, end_date)
             .paginate(page: params[:page], per_page: 15)

    @trans_count = @trans.count
  end 

  private

  def set_target_year
    if params[:target_year]
      @target_year = params[:target_year].to_i || Date.today.year
    else
      @target_year = Date.today.year if @target_year.nil?
    end
   end

  

end



