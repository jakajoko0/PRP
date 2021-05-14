class AddInvoiceReceivables
  include Interactor
  #**************************************************
  # This Interactor is called from the create_remittance
  # or update_remittance interactor and gets 
  # information from them as to what needs to happen
  #**************************************************
  def call
  	#**************************************************
    # Only write receivables if the remittance is posted
    #**************************************************
    context.invoice.prp_transactions.where(trans_type: :receivable).destroy_all

      ActiveRecord::Base.transaction do 
  		  #Get the saved remittance
  		  invoice = context.invoice
  		  #*********************************************
  		  # Create the Receivable for Invoice
  		  #*********************************************
        invoice.invoice_items.each do |item|
          PrpTransaction.create!(franchise_id: invoice.franchise_id,
                             date_posted: invoice.date_entered,
                             trans_type: :receivable,
                             trans_code: item.code,
                             trans_description: invoice.note,
                             amount: item.amount,
                             transactionable: invoice)
        end
  	  end
    
 	  rescue ActiveRecord::RecordInvalid => exception
      context.invoice.errors.add(:base, "An error occured saving credits: #{exception.message}")
 		  context.fail!
  end

  def rollback
  	context.invoice.prp_transactions.where(trans_type: :receivable).destroy_all
  end
end