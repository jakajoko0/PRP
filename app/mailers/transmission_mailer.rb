class TransmissionMailer < ApplicationMailer
	
  def transmission_notice(num_trans, translog)
  	@num_trans = num_trans
   	@translog = translog
  	mail(to: 'dgrenier@smallbizpros.com', subject: 'Bank Transmission Log')
  end

  def error_not_found(data)
   	@d = data
    mail(to: 'dgrenier@smallbizpros.com,brussell@smallbizpros.com', subject: 'Bank Reconciliation Error')            
  end

  def error_transaction(data)
    @d = data
    mail(to: 'dgrenier@smallbizpros.com,brussell@smallbizpros.com', subject: 'Bank Payment Settlement Error')
  end

  def gulf_error(msg)
    @msg = msg
    mail(to: 'dgrenier@smallbizpros.com,brussell@smallbizpros.com', subject: 'Bank Payment Settlement Error')
  end

  def settlement_notice(settlement_log, date)
    @settlement_log = settlement_log
    @num_trans = settlement_log.length
    @date = date
    mail(to: 'dgrenier@smallbizpros.com' , subject: 'Bank Reconciliation Log')
  end

  def website_payments(process_log)
    @process_log = process_log
    mail(to: 'dgrenier@smallbizpros.com,brussell@smallbizpros.com', subject: 'Monthly Website Payments')

  end
end