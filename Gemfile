source 'https://rubygems.org'

gem 'dotenv-rails', groups: [:development, :test]

gem 'rails', '4.0.4'
gem 'sqlite3'

gem 'bcrypt', '~> 3.1.7'
gem 'devise'
gem 'pundit'

gem 'active_model_serializers'

gem 'sidekiq'

gem 'fluent-logger', '~> 0.4.7'

gem 'coinbase'
gem 'cryptsy', github: 'ianunruh/cryptsy'

# Dependencies required to use the Cryptsy web client
gem 'faraday-cookie_jar'
gem 'nokogiri'
gem 'rotp'
gem 'gmail'

group :development do
  gem 'pry-rails'
  gem 'thin'

  gem 'foreman', require: false

  # Used for Sidekiq monitoring
  gem 'sinatra', require: false
end

group :test do
  gem 'rspec-rails'
end
