# frozen_string_literal: true

class Invoice < ApplicationRecord
  # This will generate and be linked to a PrpTransation
  include Transactionable
  extend FriendlyId

  belongs_to :franchise
  has_many :invoice_items, dependent: :destroy
  validates_associated :invoice_items, message: 'Errors were detected in the invoice detail'
  accepts_nested_attributes_for :invoice_items, allow_destroy: true
  audited except: [:slug], on: %i[update destroy]

  friendly_id :number_name, use: %i[sequentially_slugged scoped], scope: :franchise_id

  # Scope for Admin users
  scope :all_ordered, -> { Invoice.includes(:franchise).order('date_entered DESC') }
  scope :all_recent_pending, lambda {
                               Invoice.includes(:franchise, :invoice_items).where(paid: 0).order('date_entered DESC').limit(10)
                             }
  scope :all_recent_posted, lambda {
                              Invoice.includes(:franchise, :invoice_items).where(paid: 1).order('date_entered DESC').limit(10)
                            }
  scope :all_pending, -> { Invoice.includes(:franchise).where(paid: 0).order('date_entered DESC') }
  scope :all_posted, -> { Invoice.includes(:franchise).where(paid: 1).order('date_entered DESC') }
  # Scope for Franchise users
  scope :franchise_all, ->(fran_id) { where(franchise_id: fran_id).order('date_entered DESC') }
  scope :fran_pending, ->(fran_id) { where(franchise_id: fran_id, paid: 0).order('date_entered DESC') }
  scope :fran_posted, ->(fran_id) { where(franchise_id: fran_id, paid: 1).order('date_entered DESC') }
  scope :recent_pending, lambda { |fran_id|
                           Invoice.includes(:invoice_items).where(franchise_id: fran_id, paid: 0).order('date_entered DESC').limit(5)
                         }
  scope :recent_posted, lambda { |fran_id|
                          Invoice.includes(:invoice_items).where(franchise_id: fran_id, paid: 1).order('date_posted DESC').limit(10)
                        }

  validates :paid, presence: true
  validates :date_entered, presence: true
  validates :note, presence: true
  validates :franchise, presence: true

  def number_name
    franchise&.number_and_name
  end

  def pending?
    paid.zero?
  end

  def paid?
    paid == 1
  end

  def invoice_total
    invoice_items.map(&:amount).sum
  end

  def set_dates(date_entered)
    self.date_entered = Date.strptime(date_entered, I18n.translate('date.formats.default')) unless date_entered.blank?
  end
end
