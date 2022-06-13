# frozen_string_literal: true

# For Users to view Charges
class ChargesController < ApplicationController
  before_action :set_charge, only: %i[show]

  def show
  end

  private

  def set_charge
    @charge = PrpTransaction.find(params[:id])
  end

end
