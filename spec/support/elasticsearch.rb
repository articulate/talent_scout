RSpec.configure do |config|
  config.before :each do
    [Book, Music, Video].each do |klass|
      klass.__elasticsearch__.create_index! force: true
      klass.__elasticsearch__.refresh_index!
    end
  end
end
