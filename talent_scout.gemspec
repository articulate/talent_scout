$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "talent_scout/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "talent_scout"
  s.version     = TalentScout::VERSION
  s.authors     = ["Brian Stolz", "Robert Pearce", "Matt Elhotiby"]
  s.email       = ["bstolz@articulate.com", "rpearce@articulate.com", "melhotiby@articulate.com"]
  s.homepage    = "https://github.com/articulate/talent_scout"
  s.summary     = "Search multiple models using elasticsearch-rails"
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ["~> 4.0", "< 4.2"]
  s.add_dependency "elasticsearch-model"
  s.add_dependency "elasticsearch-rails"

  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'headless'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "sqlite3"
end
