# TalentScout
TalentScout extends an `Elasticsearch::Model` to search over
multiple indices.

## Usage
This will search the `Video`, `Music`, and `Book` indices:

```ruby
response = TalentScout.search [Video, Music, Book], { query: { query_string: { query: "Adventure", default_operator: 'AND' } } }
```

This assumes you already have code in your models to handle basic
Elasticsearch::Model functionality; for example:

```ruby
include Elasticsearch::Model
include Elasticsearch::Model::Callbacks
index_name "#{self.table_name}_#{Rails.env}_index"

settings index: { number_of_shards: 1 } do
  mappings dynamic: 'false' do
    indexes :title, type: 'string', boost: 100
  end
end
```

## How to contribute
Pull requests welcome! To contribute:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
This software is provided under the the [MIT license](MIT-LICENSE).
