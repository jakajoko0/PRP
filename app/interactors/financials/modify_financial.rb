# frozen_string_literal: true

# Interactor to isolate the business logic of Updating a Financial
class ModifyFinancial
  include Interactor

  def call
    @financial = context.financial
    @financial.assign_attributes(context.params)
    if @financial.save
      context.event_info = prepare_event_info
      context.log_event = true
      context.financial = @financial
    else
      context.financial = @financial
      context.fail!
    end
  end

  def prepare_event_info
    { fran: @financial.franchise.franchise_number,
      lastname: @financial.franchise.lastname,
      description: "Financial Record Modified for #{@financial.year}",
      user_email: context.user.email }
  end
end
