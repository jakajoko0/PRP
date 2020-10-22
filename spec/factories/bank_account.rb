require 'faker'


FactoryBot.define do
  factory :bank_account do 
    franchise
    bank_name {Faker::Bank.name}
    account_number {Faker::Bank.account_number(digits: 10)}
    last_four {Faker::Bank.account_number(digits: 4)}
    bank_token {Faker::Internet.uuid}
    routing {Faker::Bank.routing_number}
    name_on_account {Faker::Name.name}
    type_of_account {"C"}
    account_type {:checking}

    trait :savings do 
      account_type {:savings}
      type_of_account {"S"}
    end
  end

  factory :bank_account_create, class: BankAccount do 
    franchise
    routing {"061119888"}
    type_of_account {"C"}
    name_on_account {"FirstName LastName"}
    account_number {"123456789"}
    bank_name {Faker::Bank.name}
  end



end