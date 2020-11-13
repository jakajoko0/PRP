class PublicController < ApplicationController
  def main
  end

  def userpage
  	@expiring_cards = CreditCard.expiring_cards(current_user.franchise)
    @expired_cards = CreditCard.expired_cards(current_user.franchise)
    @invalid_payment_token = WebsitePreference.valid_payment_token?(current_user.franchise.id)
  end

  def adminpage
  	@current_time = DateTime.current
  	current_day = Date.today-1.month
  	@year = current_day.year
  	@month = current_day.month
  end
end
