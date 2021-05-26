# frozen_string_literal: true

# Interactor to isolate the business logic of Adding a Web Preference
class CreateWebsitePreference
  include Interactor

  def call
    website_preference = WebsitePreference.new(context.params)
    if website_preference.save
      context.website_preference = website_preference
    else
    	context.website_preference = website_preference
    	context.fail!
    end
  end
end
