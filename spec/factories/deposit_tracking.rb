require 'faker'

FactoryBot.define do 
	factory :deposit_tracking do 
		franchise
		year {Date.today.year}
		month {Date.today.month}
		deposit_date {Date.today}
		total_deposit {14000}
		accounting {1000}
		backwork {1000}
		consulting {1000}
		excluded {1000}
		other1 {1000}
		other2 {1000}
		payroll {2000}
		setup {2000}
		tax_preparation {5000}

	end
end

