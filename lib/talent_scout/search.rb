module TalentScout
  class Search
    attr_accessor :params, :response

    def initialize(models=[], params)
      @params = params
      @response = search MultiJson.load(models, symbolize_keys: true)
    end

    def search(models=[], options={})
      models = MultipleModels.new(models)

      search_options = { index: models.map(&:index_name), type: models.map(&:document_type) }
      options = search_options.merge(options)

      search = Elasticsearch::Model::Searching::SearchRequest.new(models, formatted_query, options)

      Elasticsearch::Model::Response::Response.new(models, search)
    end

    def results
      if response.response.empty?
        []
      else
        response.page(params[:page])
      end
    end

    def records
      response.results.map do |r|
        item = r['_type'].classify.constantize.where(id: r['_id']).first
        if item && r['highlight']
          item.title_highlight = r['highlight']['title'].first if r['highlight']['title']
          item.body_highlight = r['highlight']['searchable_body'].first.strip if r['highlight']['searchable_body']
        end
        item
      end.compact
    end

    def facet(name)
      response.response['facets'][name]['terms'].map do |term|
        { term['term'] => term['count'] }
      end
    end

    def type_count type
      facet('type').detect do |t|
        t[type]
      end.try(:[], type) || 0
    end

    def tag_count
      facet('tag')
    end

    def formatted_query
      facet_type = {}
      facet_tag = {}

      and_condition =
        [
            { missing: { field: :deleted_at, existence: true, null_value: true } },
            { or: [ { not: { exists: { field: :published } } }, term: { published: true } ] }
        ]

      if params[:only_type].present?
        and_condition.push({ type: { value: params[:only_type] }})
        facet_type = { term: { "_type" => params[:only_type] }}
      end

      if params[:only_tag].present?
        and_condition.push({ bool: { must: { term: { "tags.name.exact" => params[:only_tag] }}}})
        facet_tag = { term: { "tags.name.exact" => params[:only_tag] }}
      end

      search = {
        filter: {
          and: and_condition
        },
        facets: {
          type: {
            terms: {
              field: '_type'
            }
          },
          tag: {
            terms: {
              field: 'tags.name.exact'
            }
          }
        }
      }

      if facet_type.any?
        search[:facets][:type].store(:facet_filter, facet_type)
        search[:facets][:tag].store(:facet_filter, facet_type)
      end

      if facet_tag.any?
        search[:facets][:tag].store(:facet_filter, facet_tag)
        search[:facets][:type].store(:facet_filter, facet_tag)
      end

      if params[:q].present?
        search[:query] = { 
          query_string: { query: params[:q], default_operator: 'AND' }
        }
        search[:highlight] = { pre_tags: ["<b>"], post_tags: ["</b>"], fields: { title: { number_of_fragments: 0 }, searchable_body:  { number_of_fragments: 1, fragment_size: 300 } } }
      end

      if params[:search_sort].present? and ['asc', 'desc'].include?(params[:search_sort])
        search[:sort] = [ { sortable_date: { order: params[:search_sort] } } ]
      end

      search.to_json
    end
  end

  class MultipleModels < Array
    def client
      Elasticsearch::Model.client
    end

    def ancestors
      []
    end

    def default_per_page
      20
    end
  end
end
