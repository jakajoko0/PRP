# frozen_string_literal: true

# Interactor chain to create insurance record
class CreateInsurance
  include Interactor::Organizer
  organize AddInsurance, CreateEventLog
end
