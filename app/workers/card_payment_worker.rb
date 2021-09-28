class CardPaymentWorker
include Sidekiq::Worker
sidekiq_options :retry => false 
#This is the Credit Card Payment Worker. It's listening for new Credit Card Payments
#and will proceed to call the Gulf method and process the return information

  def perform(card_payment_id)
    gulf = GulfApi::Client.new
    #Find the CardPayment based on the ID passed as a parameter
    @card_payment = CardPayment.find_by(id: card_payment_id, status: "pending")
    
    begin 
      response = gulf.token_transaction(@card_payment.gms_token,@card_payment.amount,card_payment_id)     
      
      data = response.to_array(:token_transaction_response, :token_transaction_result).first
      update_card_payment(data)      
      @card_payment.save 

      if @card_payment.approved?
        @card_payment.prp_transactions.destroy_all
        desc = "Credit from Card Payment"
        PrpTransaction.create!(franchise_id: @card_payment.franchise_id,
                             date_posted: @card_payment.date_entered,
                             trans_type: :payment,
                             trans_code: "20",
                             trans_description: desc,
                             amount: @card_payment.amount,
                             transactionable: @card_payment)
        process_invoice if @card_payment.invoice_payment?
      else
        if @card_payment.declined? || @card_payment.error?
          unprocess_invoice if @card_payment.invoice_payment?
        end
      end

      CardPaymentMailer.status_change_notice(@card_payment).deliver_now
  
    rescue GulfApi::Client::GulfAPIError => e
      @card_payment.status = "error"
      @card_payment.note = e.message
      @card_payment.save
      CardPaymentMailer.status_change_notice(@card_payment).deliver_now
    end  
  end

  def update_card_payment(data)
    @card_payment.reference_id = data[:transaction_id]

    #Check if the transaction was Approved, Pending, Declined or 
    case data[:transaction_state] 
    when 'Approved'
      @card_payment.date_approved = DateTime.now
      @card_payment.status = "approved"
      @card_payment.note = data[:transaction_state] 
              
    when 'Pending'
      @card_payment.status = "pending"
      @card_payment.note = data[:transaction_state] + " , "+data[:state_reason]  
               
    when 'Declined'
      @card_payment.status = "declined"
      @card_payment.description = data[:transaction_state] + " , "+data[:state_reason]

    when 'Error'
      @card_payment.status = "error"
      @card_payment.note = data[:state_reason]
    end 
  end

  def unprocess_invoice
    inv = Invoice.find(@card_payment.invoice_id)
    inv.update_columns(paid: 0, date_posted: nil)
    if inv.web_payment?
      WebsitePayment.find_by(invoice_id: inv.id).update_columns(status: "declined" )
    end
  end

  def process_invoice
    inv = Invoice.find(@card_payment.invoice_id)
    inv.update_columns(paid: 1, date_posted: DateTime.now)
    if inv.web_payment?
      WebsitePayment.find_by(invoice_id: inv.id).update_columns(status: "processed" )
    end
  end
 

end



