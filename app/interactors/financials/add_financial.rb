# frozen_string_literal: true

# Interactor to isolate the business logic of Adding a Financial Report
class AddFinancial
  include Interactor

  def call
    @financial = Financial.new(context.params)
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
      description: "Created Financial Record for #{@financial.year}",
      user_email: context.user.email }
  end
end
