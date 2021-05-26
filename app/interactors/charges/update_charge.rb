# frozen_string_literal: true

# Interactor to isolate the business logic of Updating a Charge
class UpdateCharge
  include Interactor

  def call
    charge = context.charge
    charge.assign_attributes(context.params)
    unless context.params[:date_posted].blank?
      charge.date_posted = Date.strptime(context.params[:date_posted],
                                         I18n.translate('date.formats.default'))
    end

    if charge.save 
      context.charge = charge
    else
      context.charge = charge
      context.fail!
    end
  end
end
