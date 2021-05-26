# frozen_string_literal: true

# Interactor to isolate the business logic of Adding a Credit Card
class CreateCreditCard
  include Interactor

  def call
    @credit_card = CreditCard.new(context.params)
    if @credit_card.valid? && @credit_card.errors.empty?
      gulf = GulfApi::Client.new

      begin
        response = gulf.create_card_token(@credit_card.card_token,
                                          @credit_card.cc_type,
                                          @credit_card.cc_exp_month,
                                          @credit_card.cc_exp_year,
                                          @credit_card.cc_name,
                                          @credit_card.cc_number,
                                          @credit_card.cc_address,
                                          @credit_card.cc_city,
                                          @credit_card.cc_state,
                                          @credit_card.cc_zip)
        assign_token(response)
        if @credit_card.save
          context.credit_card = @credit_card
        else
          context.credit_card = @credit_card
          context.fail!
        end
      rescue GulfApi::Client::GulfAPIError => e
        @credit_card.errors.add(:base, e.message)
        context.credit_card = @credit_card
        context.fail!
      end

    else
      context.credit_card = @credit_card
      context.fail!
    end
  end

  def assign_token(response)
    data = response.to_array(:token_input_response, :token_input_result).first
    @credit_card.card_token = data[:token]
    @credit_card.last_four = data[:req_record_pan]
    @credit_card.card_type = @credit_card.cc_type
    @credit_card.exp_year = @credit_card.cc_exp_year
    @credit_card.exp_month = @credit_card.cc_exp_month
  end
end
