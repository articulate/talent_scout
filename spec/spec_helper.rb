ENV['RAILS_ENV'] ||= 'test'

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

if ENV['SIMPLECOV']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'
require 'pry'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end
