# frozen_string_literal: true

# Interactor to isolate the business logic of Updating an Accountant
class ModifyFranchise
  include Interactor

  def call
    @franchise = context.franchise
    @franchise.assign_attributes(context.params)
    @franchise.set_dates(context.params[:start_date],
                         context.params[:renew_date],
                         context.params[:term_date])
    if @franchise.save
      if @franchise.previous_changes.include?('advanced_rebate')
        context.log_event = true
        context.event_info = prepare_event_info
        context.franchise = @franchise
      end
    else
      context.franchise = @franchise
      context.fail!
    end
  end

  def prepare_event_info
    { fran: @franchise.franchise_number,
      lastname: @franchise.lastname,
      description: "Advanced Rebate Changed from #{@franchise.previous_changes[:advanced_rebate][0]} % to #{@franchise.previous_changes[:advanced_rebate][1]} %",
      user_email: context.user.email }
  end
end
