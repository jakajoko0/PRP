class BankRoutingsController < ApplicationController
  
  def bank_name
  	logger.debug "PARAMS!!!"
  	logger.debug "#{params}"
  	if params.has_key?(:routing_number)
  		bank_name = BankRouting.bank_name_from_routing(params[:routing_number])
  	else
  		bank_name = "NOT FOUND" 
  	end

  	@bank_name = bank_name

  	respond_to do |format|
  		format.json {render json: {bank_name: @bank_name}, status: :ok}
  		format.html {render :inline => "<%=@bank_name%>"}

  	end


  end

  
end
