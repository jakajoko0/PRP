# frozen_string_literal: true

# Interactor to isolate the business logic of Initializing a New Remittance
class NewRemittance
  include Interactor

  def call
    current_user = context.current_user
    @remittance = current_user
                 .franchise
                 .remittances.new(month: context.month,
                                  year: context.year,
                                  status: :pending)
    @deposits = DepositTracking.get_sum_by_category(current_user.franchise_id, context.year, context.month)

    unless @deposits.nil?
      @deposits.each do |d|
        addup_deposits(d)
      end

      @remittance.calculated_royalty = @remittance.calc_royalties
      @remittance.royalty = @remittance.calculated_royalty
    end

    context.remittance = @remittance
  end

  def addup_deposits(d)
    @remittance.accounting += d.accounting
    @remittance.backwork += d.backwork
    @remittance.consulting += d.consulting
    @remittance.other1 += d.other1
    @remittance.other2 += d.other2
    @remittance.payroll += d.payroll
    @remittance.setup += d.setup
    @remittance.tax_preparation += d.tax_prep
  end
end
