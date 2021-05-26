# frozen_string_literal: true

class Accountant < ApplicationRecord
  # t.bigint "franchise_id"
  # t.string "accountant_num"
  # t.string "lastname"
  # t.string "firstname"
  # t.string "initial"
  # t.string "salutation"
  # t.date "birthdate"
  # t.string "spouse_name"
  # t.date "spouse_birthdate"
  # t.integer "spouse_partner"
  # t.date "start_date"
  # t.integer "inactive"
  # t.date "term_date"
  # t.integer "cpa"
  # t.integer "mba"
  # t.integer "degree"
  # t.integer "agent"
  # t.integer "advisory_board"
  # t.text "notes"
  # t.index ["franchise_id"], name: "index_accountants_on_franchise_id"
  extend FriendlyId
  friendly_id :franchise_and_name, use: :slugged

  belongs_to :franchise

  audited except: [:slug], on: %i[update destroy]

  scope :by_number, -> { order('accountant_num') }

  validates :franchise, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :accountant_num, uniqueness: { scope: [:franchise], message: :already_exists }
  validates :ptin, length: { is: 8, message: :proper_length }, allow_nil: true, allow_blank: true
  validates :ptin, numericality: { only_integer: true, message: :numbers_only }, allow_nil: true, allow_blank: true

  def should_generate_new_friendly_id?
    name_or_number_has_changed?
  end

  def full_name
    [firstname, lastname].join(' ')
  end

  def full_denomination
    [accountant_num, firstname, lastname].join(' ')
  end

  def franchise_and_name
    [franchise&.number_and_name, accountant_num, firstname, lastname].join('-')
  end

  def number_and_name
    [accountant_num, lastname].join(' ')
  end

  def name_or_number_has_changed?
    lastname_changed? || firstname_changed? || accountant_num_changed?
  end

  def self.search(search)
    if search
      includes(:franchise).where('lower(accountants.lastname) LIKE ? OR lower(accountants.firstname) LIKE ?',
                                 "%#{search.downcase}%", "%#{search.downcase}%")
    else
      includes(:franchise).where(nil)
    end
  end

  def set_dates(start_date, birthdate, spouse_birthdate, term_date)
    self.start_date = Date.strptime(start_date, I18n.translate('date.formats.default')) unless start_date.blank?
    self.birthdate = Date.strptime(birthdate, I18n.translate('date.formats.default')) unless birthdate.blank?
    unless spouse_birthdate.blank?
      self.spouse_birthdate = Date.strptime(spouse_birthdate,
                                            I18n.translate('date.formats.default'))
    end
    unless term_date.blank?
      self.term_date = Date.strptime(term_date,
                                     I18n.translate('date.formats.default'))
    end
  end
end
