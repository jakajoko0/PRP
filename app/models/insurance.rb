class Insurance < ApplicationRecord
extend FriendlyId
friendly_id :franchise_name, use: :slugged

belongs_to :franchise

audited

validates :franchise_id, presence: {message: "Please provide Franchise"}	
validates :franchise_id, uniqueness: {message: "An insurance record already exists for this Franchise"}
validates :eo_expiration, presence: {if: :eo_entered? , message: "Please provide expiration date for E&O insurance"}
validates :gen_expiration, presence: {if: :gen_entered?, message: "Please provide expiration date for general insurance"}
validates :other_expiration, presence: {if: :other_entered?, message: "Please provide expiration date for other insurance"}
validates :other_description, presence: {if: :other_entered?, message: "Please provide description of other insurance"}


def franchise_name 
  franchise&.number_and_name
end

def self.search(search_text)
  if search_text
    Insurance.joins(:franchise).
  	select("insurances.id, franchises.franchise_number, franchises.firstname as firstname,
  		franchises.lastname as lastname, insurances.eo_insurance, insurances.eo_expiration,
  		insurances.gen_insurance, insurances.gen_expiration, 
  		insurances.other_insurance, insurances.other_expiration,
  		insurances.other_description, insurances.slug").
  	where('lower(franchises.lastname) LIKE ? OR lower(franchises.firstname) LIKE ?', "%#{search_text.downcase}%","%#{search_text.downcase}%")
  else
    Insurance.joins(:franchise).
  	select("insurances.id, franchises.franchise_number, franchises.firstname as firstname,
  		franchises.lastname as lastname, insurances.eo_insurance, insurances.eo_expiration,
  		insurances.gen_insurance, insurances.gen_expiration, 
  		insurances.other_insurance, insurances.other_expiration,
  		insurances.other_description, insurances.slug").
  	where(nil)

  end
end

def eo_entered?
  eo_insurance == 1
end

def gen_entered?
	gen_insurance == 1
end

def other_entered?
	other_insurance == 1
end

def set_dates(eo_date, gen_date, other_date)
  self.eo_expiration = Date.strptime(eo_date, I18n.translate('date.formats.default')) unless eo_date.blank?
  self.gen_expiration = Date.strptime(gen_date, I18n.translate('date.formats.default')) unless gen_date.blank?
  self.other_expiration = Date.strptime(other_date, I18n.translate('date.formats.default')) unless other_date.blank?
end

end