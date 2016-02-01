$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rules/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rules"
  s.version     = Rules::VERSION
  s.authors     = ["Anthony Zacharakis"]
  s.email       = ["anthony@lumoslabs.com"]
  s.homepage    = "https://github.com/azach/rules"
  s.summary     = "Rules engine that allows you to add customizable business rules to any ActiveRecord model."
  s.description = "Rules engine that allows you to add customizable business rules to any ActiveRecord model."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'activeresource'
  s.add_dependency 'protected_attributes'
  s.add_dependency "rails", "~> 4.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'rspec-collection_matchers'
end
