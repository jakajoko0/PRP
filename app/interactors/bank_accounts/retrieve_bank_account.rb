# frozen_string_literal: true

# Interactor to isolate the business logic of Retrieving a Bank Account
class RetrieveBankAccount
  include Interactor

  def call
    @bank_account = context.account
    gulf = GulfApi::Client.new
    begin
      response = gulf.retrieve_bank_token(@bank_account.bank_token)
      assign_data(response)
    rescue GulfApi::Client::GulfAPIError => e
      @bank_account.errors.add(:base, e.message)
      context.fail!
    end
    context.bank_account = @bank_account
  end

  def assign_data(response)
    data = response.to_array(:token_output_response, :token_output_result).first
    @bank_account.account_number = ''
    @bank_account.type_of_account = data[:req_record_type]
    @bank_account.routing = data[:ach_routing]
    @bank_account.name_on_account = data[:req_record_name]
  end
end
