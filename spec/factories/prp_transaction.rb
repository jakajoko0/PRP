require 'faker'
Faker::Config.locale = 'en-US'

FactoryBot.define do
  factory :prp_transaction do 
    franchise
    date_posted {DateTime.now}
    trans_type {1}
    trans_code {'01'}
    trans_description {Faker::Lorem.sentence(word_count: 3)}
    amount {500} 

    trait :charge do 
      trans_type {1}        
    end

    trait :credit do 
      trans_type {2}
    end

    trait :payment do 
      trans_type {3}
    end


    
  end

end