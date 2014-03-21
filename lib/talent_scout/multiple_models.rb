module TalentScout
  class MultipleModels < Array
    def client
      Elasticsearch::Model.client
    end

    def ancestors
      []
    end

   # def default_per_page
   #   20
   # end
  end
end
