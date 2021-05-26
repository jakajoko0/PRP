# frozen_string_literal: true

# Interactor to isolate the business logic of Updating a Bank Account
class UpdateBankAccount
  include Interactor

  def call
    @bank_account = context.account
    @params = context.params
    @bank_account.assign_attributes(@params)
    if @bank_account.valid? && @bank_account.errors.empty?
      gulf = GulfApi::Client.new
      begin
        response = gulf.create_bank_token(@bank_account.bank_token,
                                          @params[:type_of_account],
                                          @params[:routing],
                                          @params[:name_on_account],
                                          @params[:account_number])
        assign_token(response)

        assign_bank_name if @bank_account.bank_name.blank?

        if @bank_account.save 
          context.bank_account = @bank_account
        else
          context.bank_account = @bank_account
          context_fail!
        end
      rescue GulfApi::Client::GulfAPIError => e
        @bank_account.errors.add(:base, e.message)
        context.bank_account = @bank_account
        context.fail!
      end
    else
      context.bank_account = @bank_account
      context.fail!
    end
    
  end

  def assign_token(response)
    data = response.to_array(:token_input_response, :token_input_result).first
    @bank_account.bank_token = data[:token]
    @bank_account.last_four = data[:req_record_pan]
    @bank_account.account_type = @params[:type_of_account]
  end

  def assign_bank_name
    bname = BankRouting.bank_name_from_routing(@bank_account.routing)
    @bank_account.bank_name = bname if bname != 'NOT FOUND'
  end
end
