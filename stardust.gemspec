$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "stardust/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "stardust_rails"
  spec.version     = Stardust::VERSION
  spec.authors     = ["Bradley Wittenbrook"]
  spec.email       = ["bradley.wittenbrook@gmail.com"]
  spec.homepage    = "https://github.com/parablesoft/stardust_rails"
  spec.summary     = "GraphQL + Rails = Programmer Bliss"
  spec.description = "Modernize API development in Rails"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.0"
  spec.add_dependency "graphql", "~> 1.9.16"
  spec.add_dependency "graphiql-rails", "~> 1.7.0"
  spec.add_dependency "graphql-rails_logger", "~> 1.1.0"
  spec.add_dependency "apollo_upload_server", "2.0.0.beta.1"
  spec.add_dependency "graphql-batch", "~> 0.4.0"
  spec.add_dependency "apollo-federation", "~> 0.4.0"

end
