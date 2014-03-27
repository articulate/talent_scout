require 'elasticsearch/model'

url = ENV['BOXEN_ELASTICSEARCH_URL'] || 'http://localhost:9200'
Elasticsearch::Model.client = Elasticsearch::Client.new(url: url, logs: true)
