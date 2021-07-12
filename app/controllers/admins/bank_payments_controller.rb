# frozen_string_literal: true

# For Admins to Manage Pending Check Payments
class Admins::BankPaymentsController < ApplicationController
	before_action :set_bank_payment, only: %i[show]

	
	def show
		
	end

	


	private

	


	def set_bank_payment
		@bank_payment = BankPayment.find(params[:id])
	end

end