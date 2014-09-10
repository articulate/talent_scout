module TalentScout
  class Response < Elasticsearch::Model::Response::Response
    def records
      # group by type, then do one query per type
      grouped_by_type = results.each_with_object({}) do |result, hash|
        hash[result["_type"]] ||= []
        hash[result["_type"]] << result["_id"]
      end

      found_records = grouped_by_type.map do |klass_name, ids|
        model = klass.find do |k|
          model_name = k.is_a?(ActiveRecord::Relation) ? k.model.to_s.downcase : k.to_s.downcase
          model_name == klass_name.downcase
        end
        model.where(id: ids).to_a
      end.compact.flatten

      # re-sort based on ES hit ordering
      hits = response['hits']['hits']
      found_records.sort_by do |record|
        hits.index do |hit|
          hit['_id'].to_i == record.id.to_i && hit['_type'].downcase == record.class.name.to_s.downcase
        end
      end
    end
  end
end
