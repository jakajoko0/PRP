class UpdateCharge
	include Interactor

  def call
  	charge = context.charge
  	charge.assign_attributes(context.params)
    charge.date_posted = Date.strptime(context.params[:date_posted], I18n.translate('date.formats.default')) unless context.params[:date_posted].blank?
	  
    if charge.save
      context.charge = charge
    else
   	  context.charge = charge
  	  context.fail!
    end
  end
end