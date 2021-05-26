# frozen_string_literal: true

# Interactor to isolate the business logic of Creating a Credit
class CreateCredit
  include Interactor

  def call
    credit = PrpTransaction.new(context.params)
    unless context.params[:date_posted].blank?
      credit.date_posted = Date.strptime(context.params[:date_posted],
                                         I18n.translate('date.formats.default'))
    end
    if credit.save
      context.credit = credit
    else
      context.credit = credit
      context.fail!
    end
  end
end
