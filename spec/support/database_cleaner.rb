require 'database_cleaner'

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.use_transactional_examples = false

  DatabaseCleaner.strategy = :deletion

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end
