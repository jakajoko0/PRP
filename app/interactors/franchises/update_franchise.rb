class UpdateFranchise
  include Interactor::Organizer
  organize ModifyFranchise, CreateEventLog
end
	