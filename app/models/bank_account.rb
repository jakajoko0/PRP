class BankAccount < ApplicationRecord
  #t.bigint franchise_id
  #t.string bank_name
  #t.string last_four
  #t.string account_type
  #t.string bank_token
  #t.string slug
  enum account_type: {savings: 'S' , checking: "C"}

  extend FriendlyId
  
  friendly_id :franchise_name_bank_lastfour , use: :slugged
  belongs_to :franchise	

  audited

  attr_accessor :routing
  attr_accessor :account_number
  attr_accessor :type_of_account
  attr_accessor :name_on_account
  
  
  validates :franchise, presence: true 
  validates :routing, presence: true
  validates :account_number, presence: true
  validates :type_of_account, presence: true
  validates :name_on_account, presence: true
  validates :bank_name, presence: true

  validate :routing_format

  def should_generate_new_friendly_id?
    new_record? || name_or_number_has_changed? || super
  end

  def franchise_name_bank_lastfour
    [franchise&.number_and_name, bank_name, last_four].join("-")
  end
  
  def bank_name_and_number
    "#{bank_name} #{account_type.capitalize} ending in #{last_four}"
  end

  def name_or_number_has_changed?
    self.bank_name_changed? || self.last_four_changed?
  end

  def token_type 
    self.checking? ? 'C' : 'S'
  end

  private
  def routing_format
    digits = self.routing.to_s.split('').map(&:to_i).select{|d| (0..9).include?(d)} 
    case digits.size 
    when 9
      checksum = ( ( 3 * (digits[0] + digits[3] + digits[6]))+ 
                   ( 7 * (digits[1] + digits[4] + digits[7]))+
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