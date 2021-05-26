# frozen_string_literal: true

# Interactor to isolate the business logic of Adding an Invoice
class AddInvoice
  include Interactor

  def call
    # Create the New Invoice With Form Params
    @invoice = Invoice.new(context.params)
    @invoice.set_dates(context.params[:date_entered])
    @invoice.admin_generated = context.admin == true ? 1 : 0

    if @invoice.save
      context.event_info = prepare_event_info
      context.log_event = true
      context.invoice = @invoice
    else
      context.invoice = @invoice
      context.fail!
    end
  end

  def prepare_event_info
    { fran: @invoice.franchise.franchise_number,
      lastname: @invoice.franchise.lastname,
      description: "Other Charge for #{@invoice.note} at #{@invoice.invoice_total.to_f} created.",
      user_email: context.user.email }
  end
end
