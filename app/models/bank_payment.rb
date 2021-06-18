#frozen_string_literal: true 

class BankPayment < Payment
	
	validates :payment_date, presence: true
	validates :gms_token, presence: true 

	scope :to_transfer, -> (target_date) {where("status = 0 AND payment_date <= ?",target_date)}

	def set_dates(pmnt_date)
    self.payment_date = Date.strptime(pmnt_date, I18n.translate('date.formats.default')) unless pmnt_date.blank?
  end



end