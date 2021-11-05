#frozen_string_literal: true 

class CheckPayment < Payment
  scope :all_pending, -> {CheckPayment.includes(:franchise).where(status: ["pending","transit"]).order('date_entered DESC')}
  scope :all_active, -> {CheckPayment.includes(:franchise).where.not(status: "deleted").order('date_entered DESC')}

  scope :for_franchise_date_range, -> (franchise_id, start_date, end_date) { where("franchise_id = ? AND (date_approved >= ? AND date_approved <= ?) AND status IN (?)", franchise_id, start_date, end_date, [4] ).order("date_entered ASC")}
	scope :for_date_range, -> (start_date, end_date) {CheckPayment.includes(:franchise).where("date_posted >= ?  AN date_posted <= ? AND status IN (?)", star_date, end_date, [4])}

	validates :check_number, presence: true 
	validates :date_approved, presence: true, if: :approved?


	def set_dates(entered_date, approved_date)
		self.date_entered = Date.strptime(entered_date, I18n.translate('date.formats.default')) unless entered_date.blank?
		self.payment_date = Date.strptime(entered_date, I18n.translate('date.formats.default')) unless entered_date.blank?
		self.date_approved = Date.strptime(approved_date, I18n.translate('date.formats.default')) unless approved_date.blank?
		self.payment_date = Date.strptime(approved_date, I18n.translate('date.formats.default')) unless approved_date.blank?

	end

end