class Book < ActiveRecord::Base
  include Concerns::Searchable
end
