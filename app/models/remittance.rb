# frozen_string_literal: true

class Remittance < ApplicationRecord
	# This will generate and will be linked to a PrpTransaction
	include Transactionable
	extend FriendlyId
	belongs_to :franchise
	belongs_to :consolidated , class_name: "FranchiseConsolidation", primary_key: 'franchise_number', foreign_key: 'franchise_number', optional: true
	# This will be audited when updated or destroyed
	audited except: [:slug], on: %[update destroy]
	friendly_id :number_name_year_month, use: :slugged

	attr_accessor :franchise_name, :total_collect

	# Using an enum for the status
	enum status: {posted: 1, pending: 0}
	# Scope for Admin users
	scope :for_period, -> (year,month) { where(status: :posted, year: year, month: month) }
	scope :all_ordered, -> { Remittance.includes(:franchise).order('year DESC, month DESC') }
	scope :all_recent_pending, -> { Remittance.includes(:franchise).where(status: :pending).order('date_received DESC').limit(10) }
  scope :all_recent_posted, -> { Remittance.includes(:franchise).where(status: :posted).order('date_posted DESC').limit(10) }
  scope :all_pending, -> { Remittance.includes(:franchise).where(status: :pending).order('date_received DESC') }
  scope :all_posted, -> { Remittance.includes(:franchise).where(status: :posted).order('date_posted DESC') }
  # Scope for Franchise users
  scope :franchise_all, -> (fran_id) { where(franchise_id: fran_id).order('year DESC, month DESC') }
	scope :fran_recent, -> { where(status: :posted).order('date_posted DESC').limit(5) }
	scope :fran_pending, -> { where(status: :pending).order('date_received DESC') }
	scope :fran_posted, -> { where(status: :posted).order('date_received DESC') }
	scope :recent_pending, -> { where(status: :pending).order('date_received DESC').limit(5) }
	scope :recent_posted, ->  { where(status: :posted).order('date_posted DESC').limit(10) }
	# Scope for exports or reports
	scope :for_franchise, -> (fran_id) { where(franchise_id: fran_id) }
	scope :for_specific_year, -> (target_year) {where(year: target_year)}
  scope :for_specific_month, -> (target_month) {where(month: target_month)} 

	# Constants used for creating forms or getting totals 
	ROYALTY_RATE = 0.09
	COLLECTIONS_ATTRIBUTES = %w(accounting backwork consulting excluded other1 other2 payroll setup tax_preparation).freeze
	CREDIT_ATTRIBUTES = %w(credit1_amount credit2_amount credit3_amount credit4_amount).freeze
	ATTRIBUTES_FOR_ROYALTY = %w(accounting backwork consulting other1 other2 payroll setup tax_preparation).freeze
	COLLECTIONS_DESC = %w(Accounting Backwork Consulting Excluded Other\ 1 Other\ 2 Payroll Tax Preparation).freeze
	ATTR_DEFAULT_ZEROS = %w(accounting backwork consulting excluded other1 other2 payroll setup tax_preparation calculated_royalty minimum_royalty royalty credit1_amount credit2_amount credit3_amount credit4_amount late_fees payroll_credit_amount).freeze
	
	# Validations
	validates :year, presence: true
	validates :month, presence: true
	validates :status, presence: true
	validates :date_received, presence: true
	validates :date_posted, presence: { if: :is_posted? }
	validates :franchise, presence: true
	validates :month, uniqueness: { scope: [:franchise_id, :year], message: :month_unique }
	validates :credit1, presence: { if: :credit1_entered? }
	validates :credit2, presence: { if: :credit2_entered? }
	validates :credit3, presence: { if: :credit3_entered? }
	validates :credit4, presence: { if: :credit4_entered? }
	validates_numericality_of COLLECTIONS_ATTRIBUTES , message: :no_negative
	validates_numericality_of :royalty, greater_than_or_equal_to: 0, message: :no_negative
	validates_numericality_of :confirmation, greater_than: 0, message: :must_confirm, if: :posted?
	validate :no_repeating_credits
	validate :prior_year_rebate_balance_available, if: (:prior_year_rebate_used?)
	validates :late_reason, presence: { if: :late_royalty? }

	# Make sure we refund the prior rebate used when we destroy the record
	before_destroy :refund_prior_year_rebate, if: (:prior_year_rebate_used?)

	# Used in the slug
	def number_name_year_month
		[franchise&.number_and_name, year, month].join('-')
	end

	# Methods to check if a credit was entered
	def credit1_entered?
		credit1_amount.to_f > 0.00
	end

	def credit2_entered?
		credit2_amount.to_f > 0.00
	end

	def credit3_entered?
		credit3_amount.to_f > 0.00
	end

	def credit4_entered?
		credit4_amount.to_f > 0.00
	end

	# Is this report late?
	def late_royalty?
		late == 1
	end

	# Was payroll credit entered?
	def payroll_credit_entered?
		payroll_credit_amount.to_f > 0.00
	end
  
  # Was a prior rebate used in this report
	def prior_year_rebate_used?
		credit1 == '35' || credit2 == '35' || credit3 == '35'
	end

	# Is this report posted?
	def is_posted?
		status == 'posted'
	end

	# Is this report newly posted?
	def just_posted?
		status == 'posted' && status_was == 'pending'
	end

	# Is this report posted and re-posted
	def re_posted?
		status == 'posted' && status_was == 'posted'
	end

	# Method that returns the total of all collections
	def total_collections
		COLLECTIONS_ATTRIBUTES.reduce(0) { |sum, attribute| sum + self[attribute] }
	end

	# Method that calculates the royalties when needed
	def calc_royalties
		return ATTRIBUTES_FOR_ROYALTY.reduce(0) { |sum, attribute| sum + self[attribute] } * ROYALTY_RATE
	end
	
	# Method that returns the total credits
	def total_credits
		CREDIT_ATTRIBUTES.reduce(0) { |sum, attribute| sum + self[attribute] }
	end
	
	# Method that checks if a credit is used more than once
	def no_repeating_credits 
		credit_array = [] 
		[credit1, credit2, credit3].each do |credit|
			credit_array << credit unless credit.blank?
		end
		unless credit_array.uniq.length == credit_array.count 
			errors.add(:base, 'The same credit cannot be used multiple times')
		end
	end

	# Method that takes the date params and converts it to datetime 
	def set_dates(received_date, posted_date)
    self.date_received = Date.strptime(received_date, I18n.translate('date.formats.default')) unless received_date.blank?
    self.date_posted = Date.strptime(posted_date, I18n.translate('date.formats.default')) unless posted_date.blank?
  end

	# Method that returns initial prior year amount before it was changed
	def prior_year_rebate_before
		prev = 0
	  # Check if we had a prior year rebate amount entered before
		['credit1', 'credit2' , 'credit3'].each do |cr|
			if self.send("#{cr}_was") == '35'
			  prev = prev + self.send("#{cr}_amount_was")
			end
		end 
		return prev
	end

	# Method that returns current prior year rebate
  def prior_year_rebate_current
		cur = 0
		# Check if we had a prior year rebate entered before
		['credit1', 'credit2' , 'credit3'].each do |cr|
			if self.send(cr) == '35'
			  cur = cur + self.send("#{cr}_amount")
			end
		end 
		return cur
	end

	# Method that returns current prior year rebate amount
	def prior_year_rebate_amount(new_post)
		if new_post
			previous_amount = 0
		else
			previous_amount = prior_year_rebate_before
		end
		
		current_amount = prior_year_rebate_current

		return current_amount - previous_amount
	end

	# Method that checks if the prior year rebate balance
	# Is good enough to allow the requested credit
	def prior_year_rebate_balance_available
		# Grab the prior rebate amount and compare it with 
		# what it was before if this was changed
		previous_amount = prior_year_rebate_before

		current_amount = prior_year_rebate_current

		if self.posted?
			if just_posted?
				balance = current_amount
			else
				balance = current_amount - previous_amount
			end
		else
			balance = current_amount
		end

		prior_rebate_balance = Franchise.prior_year_balance(self.franchise_id)

		if balance > 0 && balance > prior_rebate_balance 
			errors.add(:base, "You cannot credit #{current_amount.to_s} as prior year rebate because your balance is only #{prior_rebate_balance}")
		end

	end
	
	# Method that refunds prior year rebate to Franchise
	# File in the event that the report is destroyed
	def refund_prior_year_rebate
		if self.posted?
		  amount_to_refund = prior_year_rebate_current
		  fran = Franchise.find(self.franchise_id)
		  current_balance = fran.prior_year_rebate
			new_balance = current_balance + amount_to_refund
		  fran.prior_year_rebate = new_balance
		  if !fran.save 
			  raise ActiveRecord::RecordInvalid(self)
		  end
		end

	end

	# Get smallest year used to generate date range
	def self.get_min_year
		Remittance.minimum(:year)
	end

	# Get biggest year used to generate date range
	def self.get_max_year
		Remittance.maximum(:year)
	end

	# Get report history (year/month) for a particular franchise
	# Needed to test for duplicate reports in the form
	def self.get_history(franchise_id)
		Remittance.select('year, month')
		          .where('franchise_id = ?', franchise_id)
		          .order('year DESC , month DESC')
	end

	private

	#Method called before save to convert any amounts left blank to 0.00 to eliminate issues in calculations
	def zero_if_nil
		ATTR_DEFAULT_ZEROS.each { |attr| self[attr] = 0.00 if self[attr].nil?||self[attr].blank? }
	end
end