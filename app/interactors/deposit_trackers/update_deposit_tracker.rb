# frozen_string_literal: true

# Interactor to isolate the business logic of Update a Deposit Tracker
class UpdateDepositTracker
  include Interactor
  def call
    deposit_tracking = context.deposit_tracking
    deposit_tracking.assign_attributes(context.params)
    deposit_tracking.set_dates(context.params[:deposit_date])

    if deposit_tracking.save
    	context.deposit_tracking = deposit_tracking
    else
    	context.deposit_tracking = deposit_tracking
    	context.fail!
    end
  end
end
