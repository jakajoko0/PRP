require 'faker'
Faker::Config.locale = 'en-US'

FactoryBot.define do
  factory :insurance do 
    franchise
    eo_insurance {0}
    eo_expiration {nil}
    gen_insurance {0}
    gen_expiration {nil}
    other_insurance {0}
    other_expiration {nil}
    other_description {nil}
    other2_insurance {0}
    other2_expiration {nil}
    other2_description {nil}
  end

end