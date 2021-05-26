# frozen_string_literal: true

# Interactor to isolate the business logic of updating Insurance
class ModifyInsurance
  include Interactor

  def call
    @insurance = context.insurance
    @insurance.assign_attributes(context.params)
    @insurance.set_dates(context.params[:eo_expiration],
                         context.params[:gen_expiration],
                         context.params[:other_expiration],
                         context.params[:other2_expiration])
    if @insurance.save
      context.event_info = prepare_event_info
      context.log_event = true
      context.insurance = @insurance
    else
      context.insurance = @insurance
      context.fail!
    end
  end

  def prepare_event_info
    { fran: @insurance.franchise.franchise_number,
      lastname: @insurance.franchise.lastname,
      description: 'Insurance File Modified',
      user_email: context.user.email }
  end
end
