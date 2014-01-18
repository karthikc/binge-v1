$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "elegant_import/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "elegant_import"
  s.version     = ElegantImport::VERSION
  s.authors     = ["Karthik C"]
  s.email       = ["karthik.cs@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "A rails engine that helps users upload CSV data into excel with wonderful error reporting"
  s.description = "TODO: Description of ElegantImport."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"

  s.add_development_dependency "sqlite3"
end
