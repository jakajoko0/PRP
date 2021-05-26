# frozen_string_literal: true

# Interactor to isolate the business logic of updaing an Invoice
class ModifyInvoice
  include Interactor

  def call
    # *********************************************
    # Update the Invoice with Form params
    # ****************************************************
    # Get the current Invoice (the one in the database)
    # ****************************************************
    @invoice = context.invoice

    # Assign new params
    @invoice.assign_attributes(context.params)
    @invoice.set_dates(context.params[:date_entered])
    @invoice.admin_generated = context.admin == true ? 1 : 0

    # *********************************************
    # Try the save the Invoice
    # *********************************************
    if @invoice.save
      context.invoice = @invoice
    else
      context.invoice = @invoice
      context.fail!
    end
  end

  # *************************************************
  # Rollback the saved Invoice
  # *************************************************
  def rollback
    context.invoice.destroy
  end
end
