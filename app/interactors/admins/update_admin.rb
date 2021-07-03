# frozen_string_literal: true

# Interactor to isolate the business logic of Creating a Admin User

class UpdateAdmin
	include Interactor
	include CustomValidations

	def call
		admin = context.admin
		admin.assign_attributes(context.params)

		if !email_valid?(admin.email)
			admin.errors.add(:base, "Please enter a valid email address")
			context.admin = admin
			context.fail!
		else
			if admin.save
				context.admin = admin 
			else
				context.admin = admin
				context.fail!
			end
		end
	end
end		



