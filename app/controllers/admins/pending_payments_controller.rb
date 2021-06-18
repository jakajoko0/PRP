# frozen_string_literal: true

# For User to Review their payments
class Admins::PendingPaymentsController < ApplicationController
  def index
    payments = []

    @payments = Payment.all_pending
                .paginate(:page => params[:page],
                          :per_page => 20)

    @payments_count = @payments.count
  end 
  

end



