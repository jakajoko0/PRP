#frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.2', '>= 5.2.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Gems to use Action Cable and background jobs
gem 'redis'
gem 'sidekiq', '6.1.1'
gem 'sidekiq-cron'


# Gems to handle authentication
gem 'devise', '~> 4.7', '>= 4.7.3'
gem 'devise_masquerade', '1.3.2'

# Gem to keep audit track of changes
gem 'audited', '~> 4.10'

# Gem to show better user friendly urls (slugs)
gem 'friendly_id', '~> 5.4', '>= 5.4.2'

# Enables Application Log browsing and reviewing
gem 'logster'

# To enable access restrictions on resources
gem 'cancan'

# Enables exceptions to be rescued and sent to an admin
gem 'exception_notification', '~> 4.4', '>= 4.4.3'

# Gem to paginate big results
gem 'will_paginate', '3.2.1'

# Gem to manage and streamline interactors
gem 'interactor', '~> 3.0'

# To put the App in Maintenance Mode
gem 'turnout'

# Gem to display charts
gem 'chartkick', '3.4.0'

# Gem to validate attachment sizes, content-type
gem 'active_storage_validations'
gem 'image_processing', '~> 1.2'

# Enables Application to Communicate with AWS S3
gem 'aws-sdk-s3', require: false

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Passing values to Javascript
gem 'gon'

# To make and process API calls
gem 'savon' , '2.12.0'

gem 'rubyzip', '1.3.0'

# PDF Generation
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# XLSX EXPORT
gem 'caxlsx'
gem 'caxlsx_rails'

# gem that creates fake values, mostly for testing
gem 'faker'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '6.1.0'
  gem 'rspec-rails', '4.0.2'
  gem 'spring-commands-rspec'
end

group :development do
  gem 'benchmark-ips'
  gem 'brakeman'
  gem 'bullet'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'capistrano', '~> 3.14'
  gem 'capistrano-local-precompile', '~>1.2.0', require: false
  gem 'capistrano-nginx'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rails', '~> 1.6'
  gem 'capistrano-rbenv', '~> 2.1', '>=2.1.4'
  gem 'memory_profiler'
  gem 'pry-rails'
  gem 'rubocop', '~> 1.12', require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '~> 4.1'
end

group :test do 
  gem 'capybara', '3.35.3'	
  gem 'database_cleaner'
  gem 'geckodriver-helper'
  gem 'selenium-webdriver', '3.142.6'
  gem 'webdrivers', '4.1.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

