# frozen_string_literal: true

class BankAccount < ApplicationRecord
  # t.bigint franchise_id
  # t.string bank_name
  # t.string last_four
  # t.string account_type
  # t.string bank_token
  # t.string slug
  enum account_type: { savings: 'S', checking: 'C' }

  extend FriendlyId

  friendly_id :franchise_name_bank_lastfour, use: :slugged
  belongs_to :franchise

  audited

  attr_accessor :routing, :account_number, :type_of_account, :name_on_account

  validates :franchise, presence: true
  validates :routing, presence: true
  validates :account_number, presence: true
  validates :type_of_account, presence: true
  validates :name_on_account, presence: true
  validates :bank_name, presence: true

  validate :routing_format

  before_destroy :verify_if_used

  def self.get_description_from_token(franchise_id, token)
    b = BankAccount.find_by franchise_id: franchise_id, bank_token: token
    if b.nil?
      return "UNKNOWN ACCOUNT"
    else
      return b.bank_name_and_number
    end
  end

  def should_generate_new_friendly_id?
    new_record? || name_or_number_has_changed? || super
  end

  def franchise_name_bank_lastfour
    [franchise&.number_and_name, bank_name, last_four].join('-')
  end

  def bank_name_and_number
    "#{bank_name} #{account_type.capitalize} ending in #{last_four}"
  end

  def name_or_number_has_changed?
    bank_name_changed? || last_four_changed?
  end

  def token_type
    checking? ? 'C' : 'S'
  end

  def used_in_auto_payments?
    WebsitePreference.exists?(payment_token: bank_token)
  end

  def verify_if_used
    return unless used_in_auto_payments?
    
    errors.add(:base, 'This account is being used for a recurring payment.')
    throw(:abort)
  end

  private

  def routing_format
    digits = routing.to_s.split('').map(&:to_i).select { |d| (0..9).include?(d) }
    case digits.size
    when 9
      checksum = ((3 * (digits[0] + digits[3] + digits[6])) +
                   (7 * (digits[1] + digits[4] + digits[7])) +
                         (digits[2] + digits[5] + digits[8])) % 10
      case checksum
      when 0
        true
      else
        errors.add(:routing, I18n.t('bank_account.routing_invalid'))
        false
      end
    else
      errors.add(:routing, I18n.t('bank_account.routing_invalid'))
      false
    end
  end
end
