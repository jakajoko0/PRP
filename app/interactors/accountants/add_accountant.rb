# frozen_string_literal: true

# Interactor to isolate the business logic of Adding an Accountant
class AddAccountant
  include Interactor

  def call
    @accountant = Accountant.new(context.params)
    @accountant.set_dates(context.params[:start_date],
                         context.params[:birthdate],
                         context.params[:spouse_birthdate],
                         context.params[:term_date])
    if @accountant.save
      context.event_info = prepare_event_info
      context.log_event = true
      context.accountant = @accountant
    else
      context.accountant = @accountant
      context.fail!
    end
    
  end

  def prepare_event_info
    { fran: @accountant.franchise.franchise_number,
      lastname: @accountant.franchise.lastname,
      description: "Accountant #{@accountant.accountant_num} #{@accountant.lastname} was created",
      user_email: context.user.email }
  end
end
