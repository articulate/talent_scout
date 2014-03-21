module TalentScout
  class Response < Elasticsearch::Model::Response::Response
    def records
      # group by type, then do one query per type
      grouped_by_type = results.each_with_object({}) do |result, hash|
        hash[result["_type"]] ||= []
        hash[result["_type"]] << result["_id"]
      end

      found_records = grouped_by_type.map do |klass, ids|
        klass.classify.constantize.where(id: ids).to_a
      end.compact.flatten

      # re-sort based on ES hit ordering
      hits = response['hits']['hits']
      found_records.sort_by do |record|
        hits.index do |hit|
          hit['_id'].to_s == record.id.to_s && hit['_type'] == record.class.name.to_s
        end
      end
    end
  end
end
