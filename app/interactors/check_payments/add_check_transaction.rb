class AddCheckTransaction
  include Interactor
  # **************************************************
  # This Interactor is called from the create_bank_payment
  # or update_bank_payment interactor and gets
  # information from them as to what needs to happen
  # **************************************************
  def call
    # **************************************************
    # Only write credits if the check is approved
    # **************************************************
    context.check_payment.prp_transactions.destroy_all
    ActiveRecord::Base.transaction do
      # Get the saved remittance
      @check_payment = context.check_payment

      if @check_payment.approved?

        # *********************************************
        # Create the Payment Credit
        # *********************************************
        desc = "Credit from Check Payment"
        PrpTransaction.create!(franchise_id: @check_payment.franchise_id,
                             date_posted: @check_payment.date_approved,
                             trans_type: :payment,
                             trans_code: "20",
                             trans_description: desc,
                             amount: @check_payment.amount,
                             transactionable: @check_payment)
      elsif @check_payment.declined? && @check_payment.invoice_payment == 1
        Invoice.find(@check_payment.invoice_id).update_columns(paid: 0, date_posted: nil)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    context.bank_payment.errors.add(:base, "An error occured saving credits: #{e.message}")
    context.fail!
  end

  def rollback
    context.check_payment.prp_transactions.destroy_all
  end

end
