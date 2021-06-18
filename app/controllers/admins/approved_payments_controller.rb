# frozen_string_literal: true

# For User to Review their payments
class Admins::ApprovedPaymentsController < ApplicationController
  def index
    payments = []
    set_target_year

    beg_date = DateTime.new(@target_year,1,1).beginning_of_day
    end_date = DateTime.new(@target_year,12,31).end_of_day

    @payments = Payment.all_approved_date_range(beg_date,end_date)
    @payments = @payments
                .paginate(:page => params[:page],
                          :per_page => 20)

    @payments_count = @payments.count
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



