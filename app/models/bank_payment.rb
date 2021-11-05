#frozen_string_literal: true 

class BankPayment < Payment
	
	validates :payment_date, presence: true
	validates :gms_token, presence: true 

	scope :to_transfer, -> (target_date) {where("status = 0 AND payment_date <= ?",target_date)}

	scope :for_franchise_date_range, -> (franchise_id, start_date, end_date) { where("franchise_id = ? AND (date_approved >= ? AND date_approved <= ?) AND status IN (?)", franchise_id, start_date, end_date, [4] ).order("date_entered ASC")}
	scope :for_date_range, -> (start_date, end_date) {BankPayment.includes(:franchise).where("date_posted >= ?  AN date_posted <= ? AND status IN (?)", star_date, end_date, [0,1,4])}
	
	def set_dates(pmnt_date)
    self.payment_date = Date.strptime(pmnt_date, I18n.translate('date.formats.default')) unless pmnt_date.blank?
  end



end