require 'faker'

FactoryBot.define do 
	factory :invoice_item do 
		invoice
		code {'01'}
		amount {100}
	end
end

