RSpec.configure do |config|
  config.before :each do
    Elasticsearch::Model.client.indices.delete
  end
end
