# frozen_string_literal: true

# Interactor to isolate the business logic of Adding an Insurance
class AddInsurance
  include Interactor

  def call
    @insurance = Insurance.new(context.params)
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
      description: 'Insurance File Created',
      user_email: context.user.email }
  end
end
