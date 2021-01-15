class UpdateCredit
	include Interactor

  def call
  	credit = context.credit
  	credit.assign_attributes(context.params)
    credit.date_posted = Date.strptime(context.params[:date_posted], I18n.translate('date.formats.default')) unless context.params[:date_posted].blank?
	  
    if credit.save
      context.credit = credit
    else
   	  context.credit = credit
  	  context.fail!
    end
  end
end