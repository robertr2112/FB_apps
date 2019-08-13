source 'https://rubygems.org'
ruby '2.6.0'
#ruby-gemset=Rails_fb

gem 'rails','4.2.11.1'
gem 'bcrypt', '3.1.11'
gem 'annotate'
gem 'faker', '1.8.7'
gem 'select2-rails'
gem 'simple_form', '3.5.0'
gem 'cocoon'

#
# Bootstrap support gems
#
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate', '0.0.11'
gem 'font-awesome-sass'
gem 'font-awesome-rails'
gem 'sassc-rails'

# The following Gem is used to parse the NFL page for schedules to build
# a season.
gem 'nokogiri'

# Mail support
gem 'email_validator'

# Database.  Using the same database for production/development
gem 'pg', '~> 0.20'

group :development, :test do
  gem 'rspec-rails', '~>3.7'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'childprocess', '0.8.0'
  gem 'letter_opener_web'
  gem 'pry-rails'
end

group :test do
  gem 'capybara', '2.18.0'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false, group: :test
  gem 'launchy'
  gem 'libnotify', '0.9.4'
  gem 'rubocop-rspec'
end

gem 'uglifier', '4.1.16'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.1'
gem 'jquery-turbolinks', '2.1.0'
gem 'turbolinks', '5.1.0'
gem 'jbuilder', '2.4.1'

group :doc do
  gem 'sdoc', '0.4.1', require: false
end

group :production do
  gem 'rails_12factor'
end

# To use debugger
# gem 'debugger'

gem 'execjs'
gem 'therubyracer', :platforms => :ruby
