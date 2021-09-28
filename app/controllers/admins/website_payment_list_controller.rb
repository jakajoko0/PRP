# frozen_string_literal: true

# For Admins to List, Add, Edit, Delete WebsitePreferences
class Admins::WebsitePaymentListController < ApplicationController

  def index
    @payment_summary = WebsitePayment.payments_summary
  end 

end
