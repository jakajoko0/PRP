class SendBpMail
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
      @bank_payment = context.bank_payment
      # *********************************************
      # Send Email
      # *********************************************
      BankPaymentMailer.status_change_notice(@bank_payment).deliver_now
      
  end
  

end
