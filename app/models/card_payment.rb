#frozen_string_literal: true 

class CardPayment < Payment
	validates :gms_token, presence: true 
end