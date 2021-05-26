# frozen_string_literal: true

# Interactor to isolate the business logic of Create a Deposit Tracker
class CreateDepositTracker
  include Interactor

  def call
    deposit_tracking = DepositTracking.new(context.params)
    deposit_tracking.set_dates(context.params[:deposit_date])
    Rails.logger.debug "DT: #{deposit_tracking.inspect}"

    if deposit_tracking.save
      context.deposit_tracking = deposit_tracking
    else
    	context.deposit_tracking = deposit_tracking
    	context.fail!
    end
  end
end
