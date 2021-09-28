# frozen_string_literal: true

class WebsitePreference < ApplicationRecord
  PREFERENCES = { 0 => 'Basic',
                  1 => 'Custom',
                  2 => 'Basic & Link' }.freeze
  
  attr_accessor :card_token, :bank_token                  
  
  extend FriendlyId
  friendly_id :franchise_name, use: :slugged
  
  audited except: [:slug]

  enum payment_method: { ach: 0, credit_card: 1 }

  belongs_to :franchise
  scope :for_franchise, ->(franchise_id) { where(franchise_id: franchise_id) }
  
  validates :website_preference, presence: true
  validates :card_token, presence: true, if: :credit_card_selected?
  validates :bank_token, presence: true, if: :bank_selected?
  validates :franchise, uniqueness: { message: :already_there }

  before_save :assign_payment_token

  def franchise_name
    franchise&.number_and_name
  end

  def paid_with
    payment_method == 'ach' ? 'Bank Account' : 'Credit Card'
  end

  def credit_card_selected?
    payment_method == 'credit_card'
  end

  def bank_selected?
    payment_method == 'ach'
  end

  def assign_proper_token
    if payment_method == 'ach'
      self.bank_token = payment_token
    else
      self.card_token = payment_token
    end
  end

  def preference_description
    PREFERENCES[website_preference]
  end

  def current_fee
    if website_preference.zero?
      99.00
    else
      (website_preference == 1 ? 329.99 : 149.99)
    end
  end

  def assign_payment_token
    self.payment_token = if payment_method == 'ach'
                           bank_token
                         else
                           card_token
                         end
  end

  def self.valid_payment_token?(franchise_id)
    wp = WebsitePreference.find_by(franchise_id: franchise_id)
    return true if wp.nil?

    if wp.payment_method == 'ach'
      bank_account_there?(wp.payment_token)
    else
      credit_card_there?(wp.payment_token)
    end
  end
  
  private
  
  def self.bank_account_there?(token)
    ba = BankAccount.find_by(bank_token: token)
    ba.nil? ? false : true
  end

  def self.credit_card_there?(token)
    cc = CreditCard.find_by(card_token: token)
    cc.nil? ? false : true
  end
end
