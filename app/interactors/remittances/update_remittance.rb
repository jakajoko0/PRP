class UpdateRemittance
  include Interactor::Organizer
  organize ModifyRemittance, AddReceivables, AddCredits
end
