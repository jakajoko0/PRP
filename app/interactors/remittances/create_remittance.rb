class CreateRemittance
  include Interactor::Organizer
  organize AddRemittance, AddReceivables, AddCredits
end