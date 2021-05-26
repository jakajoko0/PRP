class AddCredits
  include Interactor
  # **************************************************
  # This Interactor is called from the create_remittance
  # or update_remittance interactor and gets
  # information from them as to what needs to happen
  # **************************************************
  def call
    # **************************************************
    # Only write credits if the remittance is posted
    # **************************************************
    if context.remittance.posted?
      # First we delete any credits
      # Tied to this Remittance (easier than to change amount)
      context.remittance.prp_transactions.where(trans_type: :credit).destroy_all
      ActiveRecord::Base.transaction do
        # Get the saved remittance
        @remittance = context.remittance
        # *********************************************
        # Create the Credits if we have any
        # *********************************************
        desc = "Credit from Royalty on #{Date::MONTHNAMES[@remittance.month]} #{@remittance.year}"
        if @remittance.credit1_entered?
          add_credit(desc,@remittance.credit1,@remittance.credit1_amount)
        end

        if @remittance.credit2_entered?
          add_credit(desc,@remittance.credit2,@remittance.credit2_amount)
        end

        if @remittance.credit3_entered?
          add_credit(desc,@remittance.credit3,@remittance.credit3_amount)
        end

        if @remittance.credit4_entered?
          desc = "#{remittance.credit4} from Royalty on #{Date::MONTHNAMES[@remittance.month]} #{@remittance.year}"
          add_credit(desc, '29', @remittance.credit4_amount)
        end
        
        # If prior rebate amount was used in this remittance
        if @remittance.prior_year_rebate_used?
          # Check if the remittance was just posted
          amount = @remittance.prior_year_rebate_current if context.just_posted

          amount = @remittance.prior_year_rebate_current - context.old_prior_year_rebate if context.re_posted
          franchise = Franchise.find(@remittance.franchise_id)
          current_balance = franchise.prior_year_rebate

          new_balance = if amount > 0.00
                          current_balance - amount
                        else
                          current_balance + amount.abs
                        end
          franchise.prior_year_rebate = new_balance
          raise ActiveRecord::RecordInvalid unless franchise.save
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    context.remittance.errors.add(:base, "An error occured saving credits: #{e.message}")
    context.fail!
  end

  def rollback
    context.remittance.prp_transactions.where(trans_type: :credit).destroy_all
  end

  def add_credit(desc, code, amount)
    PrpTransaction.create!(franchise_id: @remittance.franchise_id,
                           date_posted: @remittance.date_posted,
                           trans_type: :credit,
                           trans_code: code,
                           trans_description: desc,
                           amount: amount,
                           transactionable: @remittance)

  end
end
