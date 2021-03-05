class AddRemittance
  include Interactor

  def call
  	#*********************************************
  	# Create the New Remittance with Form params 
  	#*********************************************
  	remittance = Remittance.new(context.params)
  	#*********************************************
  	# If admin, we set the date that were entered
  	#*********************************************
  	if context.admin == true 
  		remittance.set_dates(context.params[:date_received],
  			  				         context.params[:date_posted])
  	else
  		#*********************************************
  		# If franchise, we let the date received be now
  		#*********************************************
  		remittance.date_received = DateTime.now	
    end

 		#*********************************************
 		# See what the user clicked
 		#*********************************************
    case context.submit_type
    when "Save and Post"
      #Flag the Report as posted
      #Set the posted time if it`s not Admin user
    	remittance.status = :posted
    	if context.admin == false
    		remittance.date_posted = DateTime.now 
    	end

    when "Save for Later"
      #Set remittance status to pending
    	remittance.status = :pending
    end
      
    #*********************************************
    # Since this is a brand new Remittance
    # We set the flag as just posted for the
    # Other Interactors
    #*********************************************
    if remittance.posted?
      context.just_posted = true
      context.re_posted = false
    end
 			
    #*********************************************
	  #Try the save the Remittance
 		#*********************************************
  	if remittance.save 
  	  context.remittance = remittance 
  	else
  	  context.remittance = remittance
  	  context.fail!
  	end	
  end
  #*************************************************
  #Rollback the saved remittance
  #Switch the form remittance object back to pending
  #*************************************************
  def rollback
    context.remittance.destroy
    remittance.status == "pending"
  end
end