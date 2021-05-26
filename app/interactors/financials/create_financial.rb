# frozen_string_literal: true

# Interactor chain to create a financial report
class CreateFinancial
  include Interactor::Organizer
  organize AddFinancial, CreateEventLog
end
