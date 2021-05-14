require 'faker'

FactoryBot.define do 
	factory :invoice do 
		franchise
		date_entered {DateTime.now}
		date_posted {nil}
		paid {0}
		note {Faker::Lorem.sentence(word_count:4)}
		admin_generated {0}
		
		trait :paid do 
			date_posted {DateTime.now}
			paid {1}
	  end

	  trait :by_admin do 
			admin_generated {1}
	  end
	end
end

