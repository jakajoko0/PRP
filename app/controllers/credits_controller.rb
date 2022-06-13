# frozen_string_literal: true

# For Users to view credits
class CreditsController < ApplicationController
  before_action :set_credit, only: %i[show]


  def show
  end

  private

  def set_credit
    @credit = PrpTransaction.find(params[:id])
  end

end
