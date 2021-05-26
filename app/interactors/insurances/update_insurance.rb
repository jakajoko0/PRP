class UpdateInsurance
  include Interactor::Organizer
  organize ModifyInsurance, CreateEventLog
end
