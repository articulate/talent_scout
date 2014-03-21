module Concerns::Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    index_name "#{self.table_name}_#{Rails.env}_index"

    # this will handle the auto indexing as new records are added
    after_save    { __elasticsearch__.index_document refresh: true }
    after_destroy { __elasticsearch__.index_document refresh: true}

    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :title, type: 'string', boost: 100
      end
    end
  end
end
