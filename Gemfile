# rubocop:disable Style/FileName
# frozen_string_literal:true
ruby '2.3.1'
source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'puma', '~> 3.0'
gem 'bcrypt'
gem 'rack-cors'
gem 'pg'
gem 'redis'
gem 'versionist'
gem 'pusher'
gem 'dotenv-rails'
gem 'active_model_serializers'
gem 'sidekiq'
gem 'rails_12factor', group: :production
gem 'newrelic_rpm'
gem 'devise'

group :test do
  gem 'database_cleaner'
  gem 'webmock'
  gem 'fakeredis'
  gem 'simplecov'
  gem 'email_spec'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'byebug', platform: :mri
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'pry'
  gem 'pry-state'
  gem 'pry-inline'
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
