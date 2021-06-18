#frozen_string_literal: true 

class CheckPayment < Payment
  scope :all_pending, -> {CheckPayment.includes(:franchise).where(status: ["pending","transit"]).order('date_entered DESC')}
  scope :all_active, -> {CheckPayment.includes(:franchise).where.not(status: "deleted").order('date_entered DESC')}

	validates :check_number, presence: true 
	validates :date_approved, presence: true, if: :approved?


	def set_dates(entered_date, approved_date)
		self.date_entered = Date.strptime(entered_date, I18n.translate('date.formats.default')) unless entered_date.blank?
		self.payment_date = Date.strptime(entered_date, I18n.translate('date.formats.default')) unless entered_date.blank?
		self.date_approved = Date.strptime(approved_date, I18n.translate('date.formats.default')) unless approved_date.blank?
		self.payment_date = Date.strptime(approved_date, I18n.translate('date.formats.default')) unless approved_date.blank?

	end

end