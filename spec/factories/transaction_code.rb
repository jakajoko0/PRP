require 'faker'
Faker::Config.locale = 'en-US'

FactoryBot.define do 
	factory :transaction_code do 
		sequence(:code) {|n| "%02d" % n}
		description {Faker::Lorem.sentence(word_count: 3)}
		trans_type {[0,1].sample}
		show_in_royalties {false}
		show_in_invoicing {false}

		trait :credit do 
			trans_type {0}
		end

		trait :charge do 
			trans_type {1}
		end
	end
end