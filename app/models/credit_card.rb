# frozen_string_literal: true

class CreditCard < ApplicationRecord
  # t.bigint franchise_id
  # t.string card_type
  # t.string last_four
  # t.integer exp_year
  # t.integer exp_month
  # t.string card_token
  # t.string slug
  CARD_TYPES = { 'V' => 'Visa',
                 'M' => 'MasterCard',
                 'I' => 'Discover',
                 'A' => 'American Express' }.freeze
  CARD_ICONS = { 'V' => 'fab fa-cc-visa light-grey-icon',
                 'M' => 'fab fa-cc-mastercard light-grey-icon',
                 'I' => 'fab fa-cc-discover light-grey-icon',
                 'A' => 'fab fa-cc-amex light-grey-icon' }.freeze

  extend FriendlyId

  friendly_id :franchise_name_card_lastfour, use: :slugged

  belongs_to :franchise

  audited

  attr_accessor :cc_number, :cc_type, :cc_exp_month, :cc_exp_year,
                :cc_address, :cc_city, :cc_state, :cc_zip, :cc_name

  validates :franchise, presence: true
  validates :cc_number, presence: true
  validates :cc_number, length: { minimum: 15, maximum: 16, message: :wrong_size }, allow_blank: false
  validates :cc_exp_month, presence: true
  validates :cc_exp_year, presence: true
  validates :cc_type, presence: true
  validates :cc_name, presence: true
  validates :cc_address, presence: true
  validates :cc_city, presence: true
  validates :cc_state, presence: true
  validates :cc_zip, presence: true

  before_destroy :verify_if_used

  def self.get_description_from_token(franchise_id, token)
    c = CreditCard.find_by franchise_id: franchise_id, card_token: token
    if c.nil?
      return "UNKNOWN CARD"
    else
      return c.card_type_and_number
    end
  end

  def should_generate_new_friendly_id?
    new_record? || name_or_number_has_changed? || super
  end

  def franchise_name_card_lastfour
    [franchise&.number_and_name, card_type_desc, last_four].join('-')
  end

  def card_type_desc
    CARD_TYPES[card_type]
  end

  def card_icon
    CARD_ICONS[card_type]
  end

  def expiring_data
    "#{exp_month} / #{exp_year}"
  end

  def card_type_and_number
    "#{card_type_desc} #{I18n.t('credit_card.ending_in')} #{last_four}"
  end

  def name_or_number_has_changed?
    last_four_changed? || card_type_changed?
  end

  def expired?
    exp_year < Date.today.year % 100 || (exp_year == Date.today.year % 100 && exp_month < Date.today.month)
  end

  def expiring?
    next_month = (Date.today + 1.month).beginning_of_month
    in_two_months = (Date.today + 2.month).end_of_month
    range_to_check = (next_month..in_two_months)
    expiration_date = Date.new(2000 + exp_year, exp_month, 15)
    range_to_check.include?(expiration_date)
  end

  def used_in_auto_payments?
    WebsitePreference.exists?(payment_token: card_token)
  end

  def verify_if_used
    return unless used_in_auto_payments?

    errors.add(:base, 'This card is being used for a recurring payment.')
    throw(:abort)
  end

  def self.expiring_cards(franchise_id)
    cards = CreditCard.where('franchise_id = ?', franchise_id)
    cards.select { |card| card.expiring? }
  end

  def self.expired_cards(franchise_id)
    cards = CreditCard.where('franchise_id = ?', franchise_id)
    cards.select { |card| card.expired? }
  end

  def self.generate_dropdown_values(franchise_id)
    values = CreditCard.select(:card_token, :card_type, :last_four).where(franchise_id: franchise_id)
    values.each do |v|
      v.card_type = v.card_type_desc
    end
    values
  end
end
