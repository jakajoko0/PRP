# frozen_string_literal: true
class DepositTracking < ApplicationRecord
  belongs_to :franchise
  before_validation :zero_if_nil

  extend FriendlyId

  friendly_id :number_name, use: %i[sequentially_slugged scoped], scope: :franchise_id

  scope :for_current_month, lambda { |franchise_id, year, month|
                              where(franchise_id: franchise_id, year: year, month: month).order('created_at DESC')
                            }

  # List the attributes that we want to convert nil to zero
  COLLECTIONS_ATTRIBUTES = %w[accounting backwork consulting other1 other2 payroll setup tax_preparation].freeze

  ZERO_ATTRS = %w[accounting backwork consulting other1 other2 payroll setup tax_preparation total_deposit].freeze

  validates :franchise, presence: true
  validates :year, presence: true
  validates :month, presence: true
  validates :deposit_date, presence: true
  validates_numericality_of :total_deposit, :accounting, :backwork, :consulting, :other1, :other2, :payroll, :setup,
                            :tax_preparation, greater_than_or_equal_to: 0, message: :no_negative
  validates :total_deposit, uniqueness: { scope: %i[franchise_id deposit_date], message: :already_there }
  validate :total_is_sum_of_breakdown

  def number_name
    franchise&.number_and_name
  end

  def set_dates(dep_date)
    self.deposit_date = Date.strptime(dep_date, I18n.translate('date.formats.default')) unless dep_date.blank?
    self.month = deposit_date.month
    self.year = deposit_date.year
  end

  # Get smallest year used to generate date range
  def self.min_year
    DepositTracking.minimum(:year)
  end

  # Get biggest year used to generate date range
  def self.get_max_year
    DepositTracking.maximum(:year)
  end

  # Get sum by category in order to display it in the table footer
  def self.get_sum_by_category(franchise_id, r_year, r_month)
    if DepositTracking.where('franchise_id = ? and year = ? and month = ?', franchise_id, r_year, r_month).count.positive?
      DepositTracking.select(
        'SUM(accounting) as accounting, SUM(backwork) as backwork , SUM(consulting) as consulting, SUM(other1) as other1, SUM(other2) as other2, SUM(payroll) as payroll, SUM(setup) as setup, SUM(tax_preparation) as tax_prep').where('franchise_id = ? and year = ? and month = ?', franchise_id, r_year, r_month
      )
    end
  end

  private

  #  This method converts nil to zeros for the specific attributes listed above
  def zero_if_nil
    ZERO_ATTRS.each { |attr| self[attr] = 0.00 if self[attr].nil? }
  end

  def total_collections
    COLLECTIONS_ATTRIBUTES.reduce(0) { |sum, attribute| sum + self[attribute] }
  end

  #  Method that makes sure the total deposit matches the sum of the deposit breakdown
  def total_is_sum_of_breakdown
    return unless total_collections != total_deposit

    errors.add(:total_deposit, 'The sum of the deposit breakdown should match the deposit total')
  end
end
