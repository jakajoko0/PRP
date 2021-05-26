# frozen_string_literal: true

# Interactor chain to update a franchise
class UpdateFranchise
  include Interactor::Organizer
  organize ModifyFranchise, CreateEventLog
end
