 class Franchise < ApplicationRecord
# t.string   area
# t.string   mast
# t.integer   region
# t.string   franchise
# t.string   office
# t.string   firm_id
# t.string   lastname
# t.string   firstname
# t.string   city
# t.string   state
# t.datetime created_at
# t.datetime updated_at
# t.string   email
# t.de cimal  prior_year_rebate
# t.decimal  advanced_rebate
# t.integer  show_exempt_collect
# t.string   "initial"
# t.string   "salutation"
# t.string   "address"
# t.string   "address2 "
#t.string   "zip_code"
#t.string   "ship_address"
#t.string   "ship_address2"
#t.string   "ship_city"
#t.string   "ship_state"
#t.string   "ship_zip_code"
#t.string   "home_address"
#t.string   "home_address2"
#t.string   "home_city"
#t.string   "home_state"
#t.string   "home_zip_code"
#t.string   "phone"
#t.string   "phone2"
#t.string   "fax"
#t.string   "mobile"
#t.date     "start_date"
#t.date     "renew_date"
#t.date     "term_date"
#t.string   "term_reason"
#t.string   "salesman"
#t.string   "territory"
#t.string   "start_zip"
#t.string   "stop_zip"
#t.string   "alt_email"
#t.integer  "non_compliant"
#t.string   "non_compliant_reason"
#t.integer  "inactive"
#t.decimal "max_collections"
#t.decimal "avg_collections"
#t.integer "max_coll_year"
#t.integer "max_coll_month"
#t.datetime "created_at"
#t.datetime "updated_at"
#t.string "slug"
extend FriendlyId

has_many :accountants
has_many :bank_accounts
has_many :credit_cards
has_many :financials
has_one  :insurance
has_one :website_preference
has_many :users
has_many :remittances
has_many :invoices
has_many :franchise_documents
friendly_id :number_and_name, use: :slugged
audited except: [:slug, :max_collections, :avg_collections, :max_coll_year, :max_coll_month], on: [:update, :destroy]


scope :all_active, -> {where(inactive: 0)}


NULL_ATTRS = %w(start_date renew_date term_date)

before_save :nil_if_blank

#after_save :reset_name_variable, if: :name_has_changed?

#Model Validation
  validates :area,       presence: true
  validates :mast,       presence: true
  validates :region,     presence: true
  validates :franchise_number,  presence: true
  validates :office,     presence: true
  validates :lastname,   presence: true
  validates :firstname,  presence: true
  validates :email,      presence: true
  validates :phone,      presence: true
  validates :start_date, presence: true
  validates :firm_id, length: {is: 6, message: :six_characters}, allow_blank: true, allow_nil: true
  validates :address,    presence: true
  validates :city,       presence: true
  validates :state,      presence: true
  validates :zip_code,   presence: true
  validates :prior_year_rebate, numericality: {greater_than_or_equal_to: 0, message: :cannot_exceed}
  validates :advanced_rebate, numericality: {greater_than_or_equal_to: 0 ,  message: :no_negative}
  validates :franchise_number, :uniqueness => {:scope => [:region, :office], message: :already_exists }
  validates :email , format: {with: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/, message: :invalid_format}
  validates :alt_email, format: {with: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/, message: :invalid_format}, allow_blank: true 



  #================================================================= 
  #Instance Methods  
  #=================================================================
  def should_generate_new_friendly_id?
    name_has_changed?
  end

  #firstname and lastname with a space
  def full_name
    [firstname , lastname].join(' ')
  end
  #franchise number lastname and firstname
  def number_and_name
    [franchise_number , lastname, firstname].join(' ')
  end
  #lastname firstname and franchise number
  def dropdown_list
    [lastname  ,firstname, "(#{franchise_number})"].join(' ')
  end
  #franchise number and lastname
  def full_denomination
    [franchise_number, lastname].join(' ')
  end

  def one_line_address
  "#{address} #{address2}, #{city}, #{state}, #{zip_code}"
  end

  #flag to see if name changed
  def name_has_changed?
    lastname_changed? || firstname_changed?
  end
  

  def set_dates(start_date, renew_date, term_date)
    self.start_date = Date.strptime(start_date,I18n.translate('date.formats.default')) unless start_date.blank?
    self.renew_date = Date.strptime(renew_date,I18n.translate('date.formats.default')) unless renew_date.blank?
    self.term_date = Date.strptime(term_date,I18n.translate('date.formats.default')) unless term_date.blank?
  end
  #================================================================= 
  #Class Methods  
  #=================================================================
  #Method that search through the franchises based on search criterias
  #This is called from the find frachise screen
  def self.search(search)
    if search
      where('lower(lastname) LIKE ? OR lower(firstname) LIKE ?', "%#{search.downcase}%","%#{search.downcase}%")
    else
      where(nil)
    end
  end

  def self.number_and_name(franchise_id)
    @fran_by_number_and_name ||= compute_number_and_name
    return @fran_by_number_and_name[franchise_id] if @fran_by_number_and_name[franchise_id]
    result = Franchise.select("(franchise_number || ' ' || lastname || ' ' || firstname) as name").where("id =?",franchise_id)
    return @fran_by_number_and_name[franchise_id] = result[0]

  end

  def self.compute_number_and_name
    Franchise.select(:id, "(franchise_number || ' ' || lastname || ' ' || firstname) as name")
    .map{|e| e.attributes.values}
    .inject({}) {|memo,fran| memo[fran[0]] = fran[1]; memo}
  end

  def self.rebates(franchise_id)
    Franchise.select('advanced_rebate, prior_year_rebate').where("id = ?", franchise_id)
  end

  def self.prior_year_balance(franchise_id)
    result = Franchise.select('prior_year_rebate').where(id: franchise_id ).first
    return result.prior_year_rebate
  end



  private

  def nil_if_blank
    NULL_ATTRS.each {|attr| self[attr] = nil if self[attr].blank?}
  end
 

end