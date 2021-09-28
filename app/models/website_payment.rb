class WebsitePayment < ApplicationRecord
	#t.integer :year
  #t.integer :month
  #t.integer :franchise_id
  #t.decimal :fees, precision: 10, scale: 2, default: 0
  #t.integer :payment_type, default: 0
  #t.integer :status, default: 0
  #t.string  :gms_token
  #t.integer :invoice_id
  #t.timestamps

  belongs_to :franchise
  has_one :invoice

  scope :card_payments_for, -> (yr,mo) {where(year: yr, month: mo, payment_type: 1, status: 0)}
  scope :ach_payments_for, -> (yr,mo) {where(year: yr, month: mo, payment_type: 0, status: 0)}
  scope :all_payments_for, -> (yr,mo) {includes(:franchise).where(year: yr, month: mo).order("created_at ASC")}

  validates_presence_of :fees
  validates_presence_of :gms_token
  validates_presence_of :month
  validates_presence_of :year
  validates_presence_of :payment_type
  validates_presence_of :status
  validates_presence_of :franchise_id

  validates_numericality_of :fees , greater_than_or_equal_to: 0

  enum status: [:pending, :processing, :processed, :declined]
  enum payment_type: [:ach, :credit_card]

  def paid_with
	  if payment_type == "ach"
		  return BankAccount.get_description_from_token(self.franchise_id, self.gms_token)
	  else
		  return CreditCard.get_description_from_token(self.franchise_id, self.gms_token)
	  end
  end

	def self.payments_summary
	  sql = "SELECT 
	  month as mo,
	  year yr,
	  (SELECT count(*) FROM website_payments WHERE year = wp.year AND month = wp.month AND payment_type = 0) AS bank_count, 
	  (SELECT count(*) FROM website_payments WHERE year = wp.year AND month = wp.month AND payment_type = 1) AS credit_count,	
	  (SELECT count(*) FROM website_payments WHERE year = wp.year AND month = wp.month AND status = 2) AS completed
	  FROM website_payments wp
	  GROUP BY wp.month,wp.year
	  ORDER BY wp.year DESC, wp.month DESC"

	  WebsitePayment.find_by_sql([sql]) 

  end

  def self.payments
    sql = "SELECT 
    month as mo,
    year yr,
    (SELECT count(*) FROM website_payments WHERE year = wp.year AND month = wp.month AND payment_type = 0 ) AS bank_count,
    (SELECT count(*) FROM website_payments WHERE year = wp.year AND month = wp.month AND payment_type = 1 ) AS credit_count,
    (SELECT count(*) FROM website_payments WHERE year = wp.year AND month = wp.month AND status = 2 ) AS completed
   FROM website_payments wp
    GROUP BY wp.month,wp.year
    ORDER BY wp.year DESC, wp.month DESC"

    WebsitePayment.find_by_sql([sql]) 
  end

end