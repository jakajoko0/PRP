require 'faker'


FactoryBot.define do
  factory :credit_card do 
    franchise
    card_type { ["M","V","A","I"].sample }
    last_four {Faker::Bank.account_number(digits: 4)}
    exp_year {(Date.today+1.year).strftime("%y").to_i}
    exp_month {Date.today.month}
    card_token {Faker::Internet.uuid}
    cc_name {Faker::Name.name}
    cc_number {Faker::Bank.account_number(digits: 16)}
    cc_type { ["M","V","A","I"].sample }
    cc_exp_month {Date.today.month}
    cc_exp_year {(Date.today+1.year).strftime("%y").to_i}
    cc_address {Faker::Address.street_address}
    cc_city {Faker::Address.city}
    cc_state {Faker::Address.state_abbr}
    cc_zip {Faker::Address.zip}

    trait :mastercard do 
      cc_type {"M"}
      card_type {"M"}
      cc_number {"5555555555554444"}
      last_four {"4444"}
    end

    trait :visa do 
      cc_type {"V"}
      card_type {"V"}
      cc_number {"4111111111111111"}
      last_four {"1111"}
    end

    trait :amex do 
      cc_type {"A"}
      card_type {"A"}
      cc_number {"378282246310005"}
      last_four {"0005"}
    end

    trait :discover do 
      cc_type {"I"}
      card_type {"I"}
      cc_number {"6011111111111117"}
      last_four {"1117"}
    end


  end

  factory :credit_card_create, class: CreditCard do 
    franchise
    cc_type {"V"}
    cc_number {"4111111111111111"}
    cc_exp_year {(Date.today+1.year).strftime("%y").to_i}
    cc_exp_month {Date.today.month}
    cc_address {Faker::Address.street_address}
    cc_name {Faker::Name.name}
    cc_city {Faker::Address.city}
    cc_state {Faker::Address.state_abbr}
    cc_zip {Faker::Address.zip}


  end



end