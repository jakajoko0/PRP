require 'faker'


FactoryBot.define do
  factory :website_preference do 
    franchise
    website_preference {[0,1,2].sample}


    trait :ach do 
      payment_token {Faker::Internet.uuid}
      payment_method {"ach"}
      card_token {nil }
      bank_token {"#{payment_token}"}
    end

    trait :cc do 
      payment_token {Faker::Internet.uuid}
      payment_method {"credit_card"}
      card_token {"#{payment_token}"}
      bank_token {nil}
    end


  end

  factory :website_preference_create, class: WebsitePreference do 
    franchise
    website_preference {0}
    payment_method {"ach"}
    bank_token {Faker::Internet.uuid}


  end



end