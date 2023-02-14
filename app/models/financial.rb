# frozen_string_literal: true

class Financial < ApplicationRecord
  extend FriendlyId
  belongs_to :franchise
  audited except: [:slug], on: %i[update destroy]
  friendly_id :number_name_year, use: :slugged
  attr_accessor :fran_number, :franchise_name,
                :average_monthly_fee, :average_quarterly_fee

  scope :all_ordered, -> { Financial.includes(:franchise).order('year DESC, id DESC') }
  scope :for_franchise, ->(fran_id) { where(franchise_id: fran_id).order('year DESC') }
  scope :for_specific_year,-> (target_year) {where(year: target_year)}
  
  REVENUE_ATTRIBUTES = %w[acct_monthly acct_startup acct_backwork tax_prep payroll_processing other_consult erc].freeze
  REVENUE_DESC = %w[Accounting\ Monthly Startup Backwork Tax\ Preparation Payroll\ Processing Consulting ERC].freeze
  EXPENSE_ATTRIBUTES = %w[payroll_operation owner_wages owner_payroll_taxes payroll_taxes_ben_ee insurance_business
                          supplies legal_accounting marketing rent outside_labor vehicles travel utilities licenses_taxes postage repairs interests meals_entertainment bank_charges contributions office miscellaneous equipment_lease dues_subscriptions bad_debt continuing_ed property_tax telephone_data_internet software royalties marketing_material owner_health_ins owner_vehicle owner_ira_contrib amortization depreciation payroll_process_fees].freeze
  EXPENSE_DESC = %w[Payroll\ -\ Operations Owner\ -\ Salary Owner\ -\ Payroll\ taxes Payroll\ taxes\ &\ Benefits\ EE
                    Insurance\ -\ Business Supplies Legal\ &\ Accounting Marketing\ Fees Rents Outside\ Labor Vehicles Travel Utilities Licenses\ &\ Taxes Postage Repairs\ &\ Maintenance Interests Meals\ &\ Entertainment Bank\ Charges Contributions Office Miscellaneous Equipment\ Leases Dues\ &\ Subscriptions Bad\ Debts Continuing\ Education Property\ Tax Telephone/Data/Internet Software Royalties Marketing\ Material Owner\ -\ Health\ Insurance Owner\ -\ Vehicle\ Use Owner\ -\ Retirement\ Contribution Amortization Depreciation Payroll\ Processing\ Fees].freeze
  OTHER_REVENUES = %w[other_income interest_income net_gain_asset casualty_gain].freeze
  OTHER_REVENUE_DESC = %w[Other\ Income Interest\ Income Net\ Gain/Loss\ Sale\ of\ Asset Casualty\ Gain/Loss].freeze
  OTHER_EXPENSES = %w[other_expense prov_income_tax other1 other2 other3].freeze
  OTHER_EXPENSE_DESC = %w[Other\ Expense Prov.\ for\ Income\ Tax Other1 Other2 Other3].freeze

  CLIENT_COUNTS = %w[monthly_clients total_monthly_fees quarterly_clients total_quarterly_fees ind_tax_returns ind_tax_returns_revenues entity_tax_returns entity_tax_returns_revenues].freeze

  EXPENSE_ATTRIBUTES_REPORT = %w[payroll_operation owner_wages owner_payroll_taxes payroll_taxes_ben_ee
                                 total_payroll_expense insurance_business supplies legal_accounting marketing rent outside_labor vehicles travel utilities licenses_taxes postage repairs interests meals_entertainment bank_charges contributions office miscellaneous equipment_lease dues_subscriptions bad_debt property_tax telephone_data_internet royalties marketing_material accounting_costs owner_health_ins owner_vehicle owner_ira_contrib depreciation_and_amortization payroll_process_fees].freeze
  EXPENSE_DESC_REPORT = %w[Payroll\ -\ Operations Owner\ -\ Salary Owner\ -\ Payroll\ taxes
                           Payroll\ taxes\ &\ Benefits\ EE Total\ Payroll\ Expense Insurance\ -\ Business Supplies Legal\ &\ Accounting Marketing\ Fees Rents Contractor Vehicles Travel Utilities Licenses\ &\ Taxes Postage Repairs\ &\ Maintenance Interests Meals\ &\ Entertainment Bank\ Charges Contributions Office Miscellaneous Equipment\ Leases Dues\ &\ Subscriptions Bad\ Debts Property\ Tax Telephone/Data/Internet Royalties Marketing\ Material Accounting\ Costs Owner\ -\ Health\ Insurance Owner\ -\ Vehicle\ Use Owner\ -\ Retirement\ Contribution Depreciation\ &\ Amortization Payroll\ Processing\ Fees].freeze
  OTHER_REVENUES_REPORT = %w[non_padgett_revenues net_gain_asset casualty_gain].freeze
  OTHER_REVENUE_DESC_REPORT = %w[Non\ Padgett\ Revenue Net\ Gain/Loss\ Sale\ of\ Asset Casualty\ Gain/Loss].freeze
  OTHER_EXPENSES_REPORT = %w[prov_income_tax other1 other2 other3].freeze
  OTHER_EXPENSE_DESC_REPORT = %w[Prov.\ for\ Income\ Tax Other1 Other2 Other3].freeze

  validates :year, presence: true
  validates :year, uniqueness: { scope: [:franchise_id], message: :year_unique }
  validates :other1_desc, presence: { if: :other1_entered? }
  validates :other2_desc, presence: { if: :other2_entered? }
  validates :other3_desc, presence: { if: :other3_entered? }
  validates_numericality_of REVENUE_ATTRIBUTES, { greater_than_or_equal_to: 0, message: :no_negative }
  validates_numericality_of EXPENSE_ATTRIBUTES, { greater_than_or_equal_to: 0, message: :no_negative }
  validates_numericality_of OTHER_EXPENSES, { greater_than_or_equal_to: 0, message: :no_negative }
  validates_numericality_of :other_income, { greater_than_or_equal_to: 0, message: :no_negative }
  validates_numericality_of :interest_income, { greater_than_or_equal_to: 0, message: :no_negative }
  validates_numericality_of CLIENT_COUNTS, { greater_than_or_equal_to: 0, message: :no_negative }

  before_validation :zero_if_nil

  def number_name_year
    [franchise&.number_and_name, year].join('-')
  end

  def other1_entered?
    other1.to_f > 0.00
  end

  def other2_entered?
    other2.to_f > 0.00
  end

  def other3_entered?
    other3.to_f > 0.00
  end

  def total_revenues
    REVENUE_ATTRIBUTES.reduce(0) { |sum, attribute| sum + self[attribute] }
  end

  def total_expenses
    EXPENSE_ATTRIBUTES.reduce(0) { |sum, attribute| sum + self[attribute] }
  end

  def self.get_history(franchise_id)
    Financial.select('year').where(franchise_id: franchise_id).order('year DESC')
  end

  def self.get_min_year
    Financial.minimum(:year)
  end

  def self.get_max_year
    Financial.maximum(:year)
  end

  private

  def zero_if_nil
    REVENUE_ATTRIBUTES.each { |attr| self[attr] = 0.00 if self[attr].nil? || self[attr].blank? }
    EXPENSE_ATTRIBUTES.each { |attr| self[attr] = 0.00 if self[attr].nil? || self[attr].blank? }
    OTHER_REVENUES.each { |attr| self[attr] = 0.00 if self[attr].nil? || self[attr].blank? }
    OTHER_EXPENSES.each { |attr| self[attr] = 0.00 if self[attr].nil? || self[attr].blank? }
    CLIENT_COUNTS.each { |attr| self[attr] = 0.00 if self[attr].nil? || self[attr].blank? }
  end
end
