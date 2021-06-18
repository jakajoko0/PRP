# frozen_string_literal: true

# For User to List, Edit, Delete payments
class PaymentsController < ApplicationController

	def index
		@payments = current_user.franchise.payments.recent
		@processing = current_user.franchise.card_payments.pending
	end


	def refresh_partial
    @payments = current_user.franchise.payments.recent
		@processing = current_user.franchise.card_payments.pending   
    
    respond_to do |format|
      format.js
    end
  end

end