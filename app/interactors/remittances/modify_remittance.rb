# frozen_string_literal: true

# Interactor to isolate the business logic of Updating a Remittance
class ModifyRemittance
  include Interactor

  def call
    # *********************************************
    # Update the Remittance with Form params
    # ****************************************************
    # Get the current remittance (the one in the database)
    # ****************************************************
    @remittance = context.remittance
    old_status = @remittance.status
    # Grab current prior year rebate in case we need to update it
    context.old_prior_year_rebate = @remittance.prior_year_rebate_current
    # Assign new params
    @remittance.assign_attributes(context.params)

    if context.admin == true
      @remittance.set_dates(context.params[:date_received],
                            context.params[:date_posted])
    end

    set_remittance_status
    # *********************************************
    # Since this is a brand new Remittance
    # We set the flag as just posted for the
    # Other Interactors
    # *********************************************
    if @remittance.posted? && old_status == 'pending'
      context.just_posted = true
      context.re_posted = false
    else
      context.re_posted = true
      context.just_posted = false
    end

    # *********************************************
    # Try the save the Remittance
    # *********************************************
    if @remittance.save
      context.remittance = @remittance
    else
      @remittance.status = old_status
      context.remittance = @remittance
      context.fail!
    end
    
  end

  # *************************************************
  # Rollback the saved remittance
  # Switch the form remittance object back to pending
  # *************************************************
  def rollback
    context.remittance.destroy
    remittance.status == 'pending'
  end

  def set_remittance_status
    case context.submit_type
    when 'Save and Post'
      @remittance.status = :posted
      @remittance.date_posted = DateTime.now if context.admin == false

    when 'Save for Later'
      @remittance.status = :pending
    end
  end
end
