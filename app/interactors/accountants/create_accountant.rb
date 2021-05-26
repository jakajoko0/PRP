# frozen_string_literal: true

# Chained Interactors to create an Accountant
class CreateAccountant
  include Interactor::Organizer
  organize AddAccountant, CreateEventLog
end
