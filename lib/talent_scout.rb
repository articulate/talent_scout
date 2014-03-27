require 'elasticsearch/model'

module TalentScout
  autoload :Search, "talent_scout/search"
  autoload :Response, "talent_scout/response"
  autoload :MultipleModels, "talent_scout/multiple_models"

  def self.search(models=[], query={}, options={})
    models = MultipleModels.new(models)

    options.merge!({ index: models.map(&:index_name), type: models.map(&:document_type) })

    search = Elasticsearch::Model::Searching::SearchRequest.new(models, query, options)

    Response.new(models, search)
  end
end

Elasticsearch::Model.client = Elasticsearch::Client.new url: ENV['BOXEN_ELASTICSEARCH_URL'] || 'http://localhost:9200'
