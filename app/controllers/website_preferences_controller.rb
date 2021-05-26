# frozen_string_literal: true

# For User to List, Add, Edit, Delete Web Preferences
class WebsitePreferencesController < ApplicationController
  before_action :set_website_preference, only: %i[edit update]

  def index
    @website_preferences = WebsitePreference.for_franchise(current_user.franchise)
  end

  def edit
    authorize! :edit, @website_preference
    populate_dropdowns
    @website_preference.assign_proper_token
  end

  def update
    authorize! :update, @website_preference
    populate_dropdowns
    result = UpdateWebsitePreference.call(website_preference: @website_preference,
                                          params: website_preference_params,
                                          user: current_authenticated)
    if result.success?
      flash[:success] = I18n.t('website_preference.update.confirm')
      redirect_to website_preferences_path
    else
      @website_preference = result.website_preference
      render 'edit'
    end
  end

  private

  def website_preference_params
    params.require(:website_preference)
          .permit(:franchise_id, :bank_token,
                  :card_token, :payment_method)
  end

  def set_website_preference
    @website_preference = WebsitePreference.friendly.find(params[:id])
  end

  def populate_dropdowns
  	populate_bank_dropdown
  	populate_card_dropdown
  end

  def populate_bank_dropdown
    @bank_array = []
    banks = current_user.franchise.bank_accounts.order('id')
    banks.each do |b|
      @bank_array << ["#{b.bank_name} Ending In #{b.last_four}", b.bank_token]
    end
  end

  def populate_card_dropdown
    @card_array = []
    cards = CreditCard.generate_dropdown_values(current_user.franchise.id)
    cards.each do |c|
      @card_array << ["#{c.card_type} Ending In #{c.last_four}", c.card_token]
    end
  end
end
