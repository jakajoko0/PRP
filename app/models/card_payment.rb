#frozen_string_literal: true 

class CardPayment < Payment
	validates :gms_token, presence: true 

	scope :for_franchise_date_range, -> (franchise_id, start_date, end_date) { where("franchise_id = ? AND (date_approved >= ? AND date_approved <= ?) AND status IN (?)", franchise_id, start_date, end_date, [4] ).order("date_entered ASC")}
	scope :for_date_range, -> (start_date, end_date) {CardPayment.includes(:franchise).where("date_posted >= ?  AN date_posted <= ? AND status IN (?)", star_date, end_date, [4])}

end