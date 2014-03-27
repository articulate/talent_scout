require 'elasticsearch/model'

module TalentScout
  autoload :Response, "talent_scout/response"
  autoload :MultipleModels, "talent_scout/multiple_models"
  autoload :VERSION, "talent_scout/version"

  def self.search(models=[], query={}, options={})
    models = MultipleModels.new(models)

    options.merge!({ index: models.map(&:index_name), type: models.map(&:document_type) })

    search = Elasticsearch::Model::Searching::SearchRequest.new(models, query, options)

    Response.new(models, search)
  end
end
