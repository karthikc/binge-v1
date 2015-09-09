$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "binge/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "binge"
  s.version     = Binge::VERSION
  s.authors     = ["Karthik C"]
  s.email       = ["karthik.cs@gmail.com"]
  s.homepage    = "https://github.com/karthikc/binge"
  s.summary     = "A rails engine that helps users upload CSV data into excel with wonderful error reporting"
  s.description = "Description of Binge"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "carrierwave"

  s.add_development_dependency "sqlite3", "~> 1.3.10"
end
