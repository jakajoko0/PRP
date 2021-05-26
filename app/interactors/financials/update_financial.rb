# frozen_string_literal: true

# Interactor chain to update financial
class UpdateFinancial
  include Interactor::Organizer
  organize ModifyFinancial, CreateEventLog
end
