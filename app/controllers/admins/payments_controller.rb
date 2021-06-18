# frozen_string_literal: true

# For User to List, Edit, Delete payments
class Admins::PaymentsController < ApplicationController

	def index
		@payments = Payment.all_recent
	end

end