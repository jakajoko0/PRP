class CreateFranchise
  include Interactor::Organizer
  organize AddFranchise, CreateEventLog
end

