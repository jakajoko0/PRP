class CreateFranchise
	#This create franchise interactor will call AddFranchise
	#And create an event log for it.
  include Interactor::Organizer
  organize AddFranchise, CreateEventLog
end

