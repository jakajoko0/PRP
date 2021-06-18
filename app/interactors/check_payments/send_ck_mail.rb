class SendCkMail
  include Interactor
  # **************************************************
  # This Interactor is called from the create_bank_payment
  # or update_bank_payment interactor and gets
  # information from them as to what needs to happen
  # **************************************************
  def call
    # **************************************************
    # Only write credits if the remittance is posted
    # **************************************************
    # Get the saved remittance
    @check_payment = context.check_payment
    # *********************************************
    # Send Email
    # *********************************************
    CheckPaymentMailer.status_change_notice(@check_payment).deliver_now
      
  end

end
