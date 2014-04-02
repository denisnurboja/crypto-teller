source 'https://rubygems.org'

gem 'dotenv-rails', groups: [:development, :test]

gem 'rails', '4.0.4'
gem 'sqlite3'

gem 'bcrypt', '~> 3.1.7'
gem 'devise'
gem 'pundit'

gem 'active_model_serializers'

gem 'sidekiq'

gem 'coinbase'
gem 'cryptsy'

# Dependencies required to use the Cryptsy web client
gem 'faraday-cookie_jar'
gem 'nokogiri'
gem 'rotp'

group :development do
  gem 'pry-rails'
  gem 'thin'

  # Used for Sidekiq monitoring
  gem 'sinatra'
end

group :test do
  gem 'rspec-rails'
end
