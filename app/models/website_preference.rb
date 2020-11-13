class WebsitePreference < ApplicationRecord
	extend FriendlyId
	friendly_id :franchise_name, use: :slugged
	audited except: [:slug]

	belongs_to :franchise
	scope :for_franchise, -> (franchise_id) {where(franchise_id: franchise_id)}
	enum payment_method: {ach: 0, credit_card: 1}
	attr_accessor :card_token, :bank_token

	before_save :assign_payment_token

	validates :website_preference, presence: true
	validates :card_token, presence: true, if: :credit_card_selected?
	validates :bank_token, presence: true, if: :bank_selected?

	validates :franchise, uniqueness:  {message: :already_there }

  def franchise_name 
    franchise&.number_and_name
  end

	def paid_with
		self.payment_method == "ach" ? "Bank Account" : "Credit Card"
	end

	def credit_card_selected?
		self.payment_method == "credit_card"
	end

	def bank_selected?
	  self.payment_method == "ach"
  end

	def assign_proper_token
		if self.payment_method == 'ach'
			self.bank_token = self.payment_token
		else
			self.card_token = self.payment_token
		end
	end

  def preference_description
  	case self.website_preference
  	when 0
  		"Basic"
  	when 1
  		"Custom"
  	when 2
  		"Basic & Link"
  	else
  		"Basic"
  	end
  end

  def current_fee
  	self.website_preference == 0 ? 99.00 : (self.website_preference == 1 ? 329.99 : 149.99)
  end


  def assign_payment_token
	  if self.payment_method == 'ach'
		  self.payment_token = self.bank_token
	  else
		  self.payment_token = self.card_token
	  end
  end

  def self.valid_payment_token?(franchise_id)
	  wp = WebsitePreference.find_by(franchise_id: franchise_id)
	  return true if wp.nil?
	  token_to_find = wp.payment_token
	  if wp.payment_method == "ach"
		  ba = BankAccount.find_by(bank_token: token_to_find)
		  return false if ba.nil?
	  else
  		cc = CreditCard.find_by(card_token: token_to_find)
	  	return false if cc.nil?
	  end
	  return true
  end
end