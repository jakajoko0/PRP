# frozen_string_literal: true

# Interactor chain to create a bank payment
class CreateRemittance
  include Interactor::Organizer
  organize AddRemittance, AddReceivables, AddCredits, CreateEventLog
end
