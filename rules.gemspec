$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rules/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rules"
  s.version     = Rules::VERSION
  s.authors     = ["Anthony Zacharakis"]
  s.email       = ["anthony@lumoslabs.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Rules."
  s.description = "Rules engine that allows you to add customizable business rules to any ActiveRecord model."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
