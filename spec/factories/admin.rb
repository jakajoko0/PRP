require 'faker'
FactoryBot.define do 
  factory :admin do 
  	sequence(:email) {|n| "admin#{n}@example.com"}
  	password {Faker::Internet.password}
    role {"full_control"}
  end

end