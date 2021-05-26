# frozen_string_literal: true

# Interactor to isolate the business logic of updating a Web Preference
class UpdateWebsitePreference
  include Interactor

  def call
    website_preference = context.website_preference
    website_preference.assign_attributes(context.params)

    if website_preference.save
      context.website_preference = website_preference
    else
    	context.website_preference = website_preference
    	context.fail!
    end
  end
end
