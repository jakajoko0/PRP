require 'faker'

FactoryBot.define do 
	factory :remittance do 
		franchise
		year {Date.today.year}
		month {Date.today.month}
		status {0}
		date_received {DateTime.now}
		date_posted {nil}
		accounting {1000}
		backwork {2000}
		consulting {3000}
		excluded {4000}
		other1 {5000}
		other2 {6000}
		payroll {7000}
		setup {8000}
		tax_preparation {9000}
		calculated_royalty {4050}
		minimum_royalty {0}
		royalty {4050}
		credit1 {''}
		credit1_amount {0}
		credit2 {''}
		credit2_amount {0}
		credit3 {''}
		credit3_amount {0}
		credit4 {''}
		credit4_amount {0}
		late {0}
		late_reason {''}
		late_fees {0}
		payroll_credit_desc {''}
		payroll_credit_amount {0}
		confirmation {0}
		total_due {4050}


		trait :posted do 
			date_posted {DateTime.now}
			confirmation {1}
			status {1}
	  end

	end
end

