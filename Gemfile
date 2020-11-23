source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'devise'


gem "interactor", "~> 3.0"
#Gem to help login As another user
gem 'devise_masquerade'

#Gem to keep audit track of changes
gem 'audited', '4.9.0'

#Gem to display charts
gem 'chartkick', '3.4.0'

#Gem to show better user friendly urls (slugs) 
gem 'friendly_id', '~> 5.2.4'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'will_paginate', '3.2.1'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Enables exceptions to be rescued and sent to an admin
gem 'exception_notification'

gem 'redis'

# Enables Application Log browsing and reviewing
gem 'logster'
# Passing values to Javascript
gem 'gon'
# To put the App in Maintenance Mode
gem 'turnout'
# To enable access restrictions on resources
gem 'cancan'
# To enable API calls 
gem 'savon' , '2.12.0'
# To process background jobs
gem 'sidekiq', '6.1.1' 
gem 'sidekiq-cron'
gem 'rubyzip', '1.3.0'

#PDF Generation
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

#XLSX EXPORT
gem 'caxlsx'
gem 'caxlsx_rails'

gem 'faker'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'bullet'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '3.8.1'
  gem 'spring-commands-rspec'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', '~> 3.14'
  gem 'capistrano-rails', '~> 1.6'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rbenv', '~> 2.1', '>=2.1.4'
  gem 'capistrano-nginx'
  gem 'capistrano-local-precompile', '~>1.2.0', require: false
end

group :test do 
  gem 'capybara', '3.29.0'	
  gem 'selenium-webdriver', '3.142.6'
  gem 'database_cleaner'
  gem 'geckodriver-helper'
  gem 'webdrivers', '4.1.2'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

