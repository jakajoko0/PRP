# frozen_string_literal: true

# Interactor to isolate the business logic of Creating a Admin User
class CreateAdmin
  include Interactor
  include CustomValidations

  def call
  	admin = Admin.new(context.params)
    
    if !email_valid?(admin.email)
    	admin.errors.add(:base, 'Please enter a valid email')
      context.admin = admin
      context.fail!
    else
    	temp_password = SecureRandom.hex(10)
  	  admin.password = temp_password
  	  admin.password_confirmation = temp_password
  	  admin.time_zone = "Eastern Time (US & Canada)"

  	  if admin.save
  	  	admin.reset_pass
  	    context.admin = admin
  	  else
  		  context.admin = admin
  		  context.fail!
  	  end
  	end
  end
end