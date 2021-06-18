#frozen_string_literal: true 

# For Admins to List, Add, Edit, Delete Check Payments
class Admins::ReceiptsController < ApplicationController
	def index
		@check_payments = CheckPayment.all_active.paginate(per_page: 20, page: params[:page])
    authorize! :read, CheckPayment
	end
end