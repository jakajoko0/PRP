#frozen_string_literal: true 

class Payment < ApplicationRecord
	include Transactionable
	belongs_to :franchise

	enum status: { pending: 0, transit: 1, error: 2, declined: 3, approved: 4, deleted: 5 }

	scope :recent, -> { where.not(status: "deleted").order('date_entered DESC').limit(20) }
  scope :all_recent, -> { Payment.includes(:franchise).where.not(status: "deleted").order('date_entered DESC').limit(20) } 
  scope :all_by_date_range, -> (start_date, end_date) { Payment.includes(:franchise).where.not(status: "deleted").where("date_entered >= ? AND date_entered <= ?", start_date, end_date).order('date_entered DESC') }
  scope :all_pending, -> { Payment.includes(:franchise).where(status: [:pending, :transit]).order('date_entered DESC') }
  scope :all_approved_date_range, -> (start_date, end_date) {Payment.includes(:franchise).where(status: "approved").where("date_entered >= ? AND date_entered <=?",start_date, end_date).order("date_entered DESC") }
  scope :all_declined_errors, -> { Payment.includes(:franchise).where(status: [:error, :declined]).order("date_entered DESC") }
  scope :by_date_range, -> (start_date, end_date) { where.not(status: "deleted").where("date_entered >= ? AND date_entered <= ?", start_date, end_date).order('date_entered DESC').limit(20) }
  
	
	validates :date_entered, presence: true 
	validates :amount, presence: true 
  validates :amount, numericality: { greater_than: 0, message: :no_negative }
  

  def invoice_payment?
  	self.invoice_payment == 1
  end

end