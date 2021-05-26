# frozen_string_literal: true

# Interactor chain to create a franchise
class CreateFranchise
  include Interactor::Organizer
  organize AddFranchise, CreateEventLog
end
