# frozen_string_literal: true

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
  # t.string   "zip_code"
  # t.string   "ship_address"
  # t.string   "ship_address2"
  # t.string   "ship_city"
  # t.string   "ship_state"
  # t.string   "ship_zip_code"
  # t.string   "home_address"
  # t.string   "home_address2"
  # t.string   "home_city"
  # t.string   "home_state"
  # t.string   "home_zip_code"
  # t.string   "phone"
  # t.string   "phone2"
  # t.string   "fax"
  # t.string   "mobile"
  # t.date     "start_date"
  # t.date     "renew_date"
  # t.date     "term_date"
  # t.string   "term_reason"
  # t.string   "salesman"
  # t.string   "territory"
  # t.string   "start_zip"
  # t.string   "stop_zip"
  # t.string   "alt_email"
  # t.integer  "non_compliant"
  # t.string   "non_compliant_reason"
  # t.integer  "inactive"
  # t.decimal "max_collections"
  # t.decimal "avg_collections"
  # t.integer "max_coll_year"
  # t.integer "max_coll_month"
  # t.datetime "created_at"
  # t.datetime "updated_at"
  # t.string "slug"

  extend FriendlyId
  has_many :franchise_consolidations, dependent: :destroy
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
  has_many :deposit_trackings
  has_many :payments
  has_many :bank_payments
  has_many :card_payments
  has_many :check_payments
  friendly_id :number_and_name, use: :slugged
  audited except: %i[slug max_collections avg_collections max_coll_year max_coll_month], on: %i[update destroy]

  scope :all_active, -> { where(inactive: 0) }

  attr_accessor :balance
  attr_accessor :total_collections

  NULL_ATTRS = %w[start_date renew_date term_date].freeze

  #Validates the consolidation transactions
  validates_associated :franchise_consolidations, :message => "Error detected in Franchise Consolidation"
  
  #Franchise accepts nested attributes for Franchise Cons (consolidation)
  accepts_nested_attributes_for :franchise_consolidations , :allow_destroy => true

  before_save :nil_if_blank
  after_save :reset_name_variable, if: :name_has_changed?

  # Model Validation
  validates :area,       presence: true
  validates :mast,       presence: true
  validates :region,     presence: true
  validates :franchise_number, presence: true
  validates :office,     presence: true
  validates :lastname,   presence: true
  validates :firstname,  presence: true
  validates :email,      presence: true
  validates :phone,      presence: true, allow_nil: true
  validates :start_date, presence: true
  validates :firm_id, length: { is: 6, message: :six_characters }, allow_blank: true, allow_nil: true
  validates :address,    presence: true
  validates :city,       presence: true
  validates :state,      presence: true
  validates :zip_code,   presence: true
  validates :prior_year_rebate, numericality: { greater_than_or_equal_to: 0, message: :cannot_exceed }
  validates :advanced_rebate, numericality: { greater_than_or_equal_to: 0, message: :no_negative }
  validates :minimum_royalty, numericality: {greater_than_or_equal_to: 0.00, message: :no_negative}
  validates :franchise_number, uniqueness: { scope: %i[region office], message: :already_exists }
  validates :email, format: { with: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/, message: :invalid_format }
  validates :alt_email, format: { with: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/, message: :invalid_format },
                        allow_blank: true

  #=================================================================
  # Instance Methods
  #=================================================================
  def should_generate_new_friendly_id?
    name_has_changed?
  end

  # firstname and lastname with a space
  def full_name
    [firstname, lastname].join(' ')
  end

  # franchise number lastname and firstname
  def number_and_name
    [franchise_number, lastname, firstname].join(' ')
  end

  # lastname firstname and franchise number
  def dropdown_list
    [lastname, firstname, "(#{franchise_number})"].join(' ')
  end

  # franchise number and lastname
  def full_denomination
    [franchise_number, lastname].join(' ')
  end

  def consolidator?
    self.franchise_consolidations.any?
  end
  
  def consolidated?
    FranchiseConsolidation.exists?(franchise_number: self.franchise_number)
  end

  def consolidation_status
    fran_id = FranchiseConsolidation.find_by(franchise_number: self.franchise_number).franchise_id || 0
    if self.id == fran_id
      "Consolidates ( "+FranchiseConsolidation.where('franchise_id = ?', self.id).pluck(:franchise_number).join(',')+" )"
    else
      "Consolidated under ( "+Franchise.get_franchise_number(fran_id) + " " + Franchise.get_lastname(fran_id)+" )"
    end
  end

  def one_line_address
    "#{address} #{address2}, #{city}, #{state}, #{zip_code}"
  end

  # flag to see if name changed
  def name_has_changed?
    lastname_changed? || firstname_changed?
  end

  def set_dates(start_date, renew_date, term_date)
    self.start_date = Date.strptime(start_date, I18n.translate('date.formats.default')) unless start_date.blank?
    self.renew_date = Date.strptime(renew_date, I18n.translate('date.formats.default')) unless renew_date.blank?
    self.term_date = Date.strptime(term_date, I18n.translate('date.formats.default')) unless term_date.blank?
  end

  def has_minimum_royalty?
    minimum_royalty.positive?
  end

  def calculate_total_averages(month,year)
    remittance_record = Remittance.where('franchise_id = ?',self.id).order(Arel.sql('(accounting + backwork + consulting + other1 + other2 + payroll + setup + tax_preparation ) DESC ')).first
    avg_remittance = Remittance.where('franchise_id = ? and (year = ? AND month >= ? or year = ? AND month < ?)',self.id, year-1, month, year, month).average('accounting + backwork + consulting + other1 + other2 + payroll + setup + tax_preparation')

    self.max_collections = remittance_record.total_collections if remittance_record
    self.avg_collections = avg_remittance.round(2)  if avg_remittance
    self.max_coll_year = remittance_record.year if remittance_record
    self.max_coll_month = remittance_record.month if remittance_record
  end

  #=================================================================
  # Class Methods
  #=================================================================
  # Method that search through the franchises based on search criterias
  # This is called from the find frachise screen
  def self.search(search)
    if search
      where('lower(lastname) LIKE ? OR lower(firstname) LIKE ?', "%#{search.downcase}%", "%#{search.downcase}%")
    else
      where(nil)
    end
  end

  def self.get_franchise_number(franchise_id)
    #Here we cache the franchise list so we can easily return the number 
    #after the first call. This will speed up some screens
    @fran_by_number ||= compute_number
    return @fran_by_number[franchise_id] if @fran_by_number[franchise_id]
    result = Franchise.select('franchise_number').where('id = ?',franchise_id)
    return @fran_by_number[franchise_id]  = result[0].franchise_number
  end

  def self.compute_number 
    Franchise.select(:id, :franchise_number)
    .map {|e| e.attributes.values}
    .inject({}) {|memo, fran| memo[fran[0]] = fran[1]; memo}
  end

   def self.get_lastname(franchise_id)
    #Here we cache the franchise list so we can easily return the number 
    #after the first call. This will speed up some screens
    @fran_by_lastname ||= compute_franchise_lastname
    return @fran_by_lastname[franchise_id] if @fran_by_lastname[franchise_id]
    result = Franchise.select('lastname').where('id = ?',franchise_id)
    return @fran_by_lastname[franchise_id] = result[0].lastname
  end

  def self.compute_franchise_lastname
    Franchise.select(:id, :lastname)
    .map {|e| e.attributes.values}
    .inject({}) {|memo, fran| memo[fran[0]] = fran[1]; memo}
  end

  def self.directory(last,first,state)
    scope = Franchise.where("inactive = ?", 0)
    if last && !last.blank?
      scope = scope.where("lower(lastname) LIKE ?","%#{last.downcase}%")
    end
    if first && !first.blank?
      scope = scope.where("lower(firstname) LIKE ?","%#{first.downcase}%")
    end
    if state && !state.blank?
      scope = scope.where("upper(state) = ?",state.upcase)
    end
    return scope
  end


  def self.number_and_name(franchise_id)
    @fran_by_number_and_name ||= compute_number_and_name
    return @fran_by_number_and_name[franchise_id] if @fran_by_number_and_name[franchise_id]

    result = Franchise.select("(franchise_number || ' ' || lastname || ' ' || firstname) as name").where('id = ?',
                                                                                                         franchise_id)
    @fran_by_number_and_name[franchise_id] = result[0]
  end

  def self.compute_number_and_name
    Franchise.select(:id, "(franchise_number || ' ' || lastname || ' ' || firstname) as name")
             .map { |e| e.attributes.values }
             .each_with_object({}) { |fran, memo| memo[fran[0]] = fran[1]; }
  end

  def self.compute_fullname
    Franchise.select(:id, "(firstname || ' ' || lastname) as name")
    .map {|e| e.attributes.values}
    .inject({}) {|memo, fran| memo[fran[0]] = fran[1]; memo}
  end

  def self.rebates(franchise_id)
    Franchise.select('advanced_rebate, prior_year_rebate').where('id = ?', franchise_id)
  end

  def self.prior_year_balance(franchise_id)
    result = Franchise.select('prior_year_rebate').where(id: franchise_id).first
    result.prior_year_rebate
  end

  def self.reset_fullname
    @fran_by_fullname = compute_fullname
  end

  def self.reset_lastname
    @fran_by_lastname = compute_franchise_lastname
  end

  def self.franchise_list_with_consol_flag
    Franchise.select("franchises.*, COUNT(franchise_consolidations.id) as consol")
    .joins("LEFT OUTER JOIN franchise_consolidations ON (franchise_consolidations.franchise_id = franchises.id)")
    .group("franchises.id").order("franchises.lastname ASC")
  end

  private

  def nil_if_blank
    NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end

  #method that resets the class variables that kees names for quick reference
  def reset_name_variable
    Franchise.reset_fullname
    Franchise.reset_lastname
  end

end
