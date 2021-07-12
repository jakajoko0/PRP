# frozen_string_literal: true

# For Admins to Review Card Payments
class Admins::CardPaymentsController < ApplicationController
	before_action :set_card_payment, only: %i[show]

	
	def show
	end


	private

	


	def set_card_payment
		@card_payment = CardPayment.find(params[:id])
	end

end