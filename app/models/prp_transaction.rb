# frozen_string_literal: true

class PrpTransaction < ApplicationRecord
  belongs_to :franchise
  # Can belong to any transactionable entity (royalty, payment, invoice)
  belongs_to :transactionable, polymorphic: true, optional: true

  
  # Audit updates or deletions
  audited  on: %i[update destroy]

  validates :franchise, presence: true
  validates :date_posted, presence: true
  validates :trans_type, presence: true
  validates :trans_code, presence: { message: 'Please select Transaction Code' }
  validates_numericality_of :amount, { greater_than_or_equal_to: 0, message: 'Please enter an amount' }

  # Enum for Trans Types
  enum trans_type: { receivable: 1, credit: 2, payment: 3 }

  # Scopes for Admin users
  scope :all_credits, -> { includes(:franchise).where(trans_type: 2).order('date_posted DESC') }
  scope :all_charges, -> { includes(:franchise).where(trans_type: 1).order('date_posted DESC') }
  scope :latest, -> {includes(:franchise,:transactionable).order('date_posted DESC').limit(10)}
  scope :by_date_range, ->(start_date, end_date) {includes(:franchise, :transactionable).where("date_posted >= ? and date_posted <=?",start_date, end_date).order("date_posted DESC")}
  # Scopes for Franchise Users
  scope :credits_for_franchise, ->(fran_id) { where(franchise_id: fran_id, trans_type: 2).order('date_posted DESC') }
  scope :charges_for_franchise, ->(fran_id) { where(franchise_id: fran_id, trans_type: 1).order('date_posted DESC') }
  scope :invoice_payment_for_franchise, ->(fran_id) { where(franchise_id: fran_id, transactionable_type: 'Payment').joins("INNER JOIN payments ON prp_transactions.transactionable_id = payments.id").where(payments: {invoice_payment: 1}) }
  scope :royalty_payment_for_franchise, ->(fran_id) { where(franchise_id: fran_id, transactionable_type: 'Payment').joins("INNER JOIN payments ON prp_transactions.transactionable_id = payments.id").where(payments: {invoice_payment: 0}) }
  
  def quick_info
    "Transaction Code #{trans_code} for #{amount} on #{date_posted} for #{franchise.number_and_name}"
  end

  def self.get_min_year
    PrpTransaction.minimum(:date_posted).year
  end

  def self.get_max_year
    PrpTransaction.maximum(:date_posted).year
  end
end
