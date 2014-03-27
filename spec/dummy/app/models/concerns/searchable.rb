module Concerns::Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    index_name "#{self.table_name}_#{Rails.env}_index"

    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :title, type: 'string', boost: 100
      end
    end
  end
end
