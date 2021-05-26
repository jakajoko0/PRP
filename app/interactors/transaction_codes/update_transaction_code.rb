# frozen_string_literal: true

# Interactor to isolate the business logic of updating a Transaction Code
class UpdateTransactionCode
  include Interactor

  def call
    trans_code = context.trans_code
    trans_code.code = context.params[:code]
    trans_code.description = context.params[:description]
    trans_code.trans_type = context.params[:trans_type].to_i
    trans_code.show_in_royalties = context.params[:show_in_royalties]
    trans_code.show_in_invoicing = context.params[:show_in_invoicing]
    if trans_code.save
      context.trans_code = trans_code
    else
      context.trans_code = trans_code
      context.fail!
    end
  end
end
