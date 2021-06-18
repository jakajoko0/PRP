class AddPaymentTransaction
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
    context.bank_payment.prp_transactions.destroy_all
    ActiveRecord::Base.transaction do
      
      # Get the saved remittance
      @bank_payment = context.bank_payment
      # *********************************************
      # Create the Payment Credit
      # *********************************************
      desc = "Credit from ACH Payment"
      PrpTransaction.create!(franchise_id: @bank_payment.franchise_id,
                             date_posted: @bank_payment.date_entered,
                             trans_type: :payment,
                             trans_code: "20",
                             trans_description: desc,
                             amount: @bank_payment.amount,
                             transactionable: @bank_payment)

      if @bank_payment.invoice_payment == 1 
        Invoice.find(@bank_payment.invoice_id).update_columns(paid: 1, date_posted: DateTime.now)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    context.bank_payment.errors.add(:base, "An error occured saving credits: #{e.message}")
    context.fail!
  end

  def rollback
    context.bank_payment.prp_transactions.where(trans_type: :credit).destroy_all
  end

end
