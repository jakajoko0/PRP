# frozen_string_literal: true

# Interactor chain to create a remittance
class CreateRemittance
  include Interactor::Organizer
  organize AddRemittance, AddReceivables, AddCredits, CreateEventLog
end
