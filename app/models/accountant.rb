class Accountant < ApplicationRecord
  #t.bigint "franchise_id"
  #t.string "accountant_num"
  #t.string "lastname"
  #t.string "firstname"
  #t.string "initial"
  #t.string "salutation"
  #t.date "birthdate"
  #t.string "spouse_name"
  #t.date "spouse_birthdate"
  #t.integer "spouse_partner"
  #t.date "start_date"
  #t.integer "inactive"
  #t.date "term_date"
  #t.integer "cpa"
  #t.integer "mba"
  #t.integer "degree"
  #t.integer "agent"
  #t.integer "advisory_board"
  #t.text "notes"
  #t.index ["franchise_id"], name: "index_accountants_on_franchise_id"
  extend FriendlyId
  friendly_id :franchise_and_name , use: :slugged
  
  belongs_to :franchise	

  audited
  
  after_create :log_new_accountant
  scope :by_number, -> { order("accountant_num")}

  validates :franchise, presence: {message: "Please provide Franchise"}
  validates :firstname, presence: {message: "First name cannot be blank"}
  validates :lastname, presence: {message: "Last name cannot be blank"}
  validates :accountant_num, uniqueness: {scope: [:franchise], message: "This accountant number already exists"}

  def should_generate_new_friendly_id?
    name_or_number_has_changed?
  end

  
  def full_name
    [firstname,lastname].join(" ")
  end

  def full_denomination
    [accountant_num, firstname, lastname].join(" ")
  end

  def franchise_and_name
    [franchise&.number_and_name, accountant_num, firstname, lastname].join("-")
  end
  

  def number_and_name
    [accountant_num, lastname].join(" ")
  end

  def name_or_number_has_changed?
    lastname_changed? || firstname_changed? || accountant_num_changed?
  end


  def self.search(search)
    if search
      includes(:franchise).where('lower(accountants.lastname) LIKE ? OR lower(accountants.firstname) LIKE ?', "%#{search.downcase}%","%#{search.downcase}%")
    else
      includes(:franchise).where(nil)
    end
  end

  def set_dates(start_date, birthdate, spouse_birthdate, term_date)
    self.start_date = Date.strptime(start_date,I18n.translate('date.formats.default')) unless start_date.blank?
    self.birthdate = Date.strptime(birthdate,I18n.translate('date.formats.default')) unless birthdate.blank?
    self.spouse_birthdate = Date.strptime(spouse_birthdate,I18n.translate('date.formats.default')) unless spouse_birthdate.blank?
    self.term_date = Date.strptime(term_date,I18n.translate('date.formats.default')) unless term_date.blank?
  end

  private  

  def log_new_accountant
    desc = "Accountant #{self.accountant_num} #{self.lastname} was created"
    EventLog.create(event_date: DateTime.now, fran: self.franchise.franchise_number, lastname: self.franchise.lastname, user_email: self.franchise.email, event_desc: desc)
  end


end