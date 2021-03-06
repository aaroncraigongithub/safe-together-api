# frozen_string_literal:true
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort('The Rails environment is running in production mode!') \
  if Rails.env.production?

require 'sidekiq/testing'
require 'email_spec'
require 'email_spec/rspec'
require 'spec_helper'
require 'rspec/rails'
Dir[Rails.root.join('spec/shared/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
