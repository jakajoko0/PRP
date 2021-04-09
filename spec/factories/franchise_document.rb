require 'faker'

FactoryBot.define do 
  factory :franchise_document do 
    association :franchise
    description {Faker::Lorem.sentence(word_count: 3)}
    document_type { [1,2,5].sample }
	  document {fixture_file_upload(Rails.root.join('spec','factories','files','taxreturn2020.xlsx'),'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')}

	  trait :with_invalid_document do 
  		document {fixture_file_upload(Rails.root.join('spec','factories','files','TextFile.txt'),'text/plain')}
  	end
  end
end
