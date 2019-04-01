$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "users/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "users"
  spec.version     = Users::VERSION
  spec.authors     = ["Whil Piavis"]
  spec.email       = ["ncsupiratecaptain@gmail.com"]
  spec.homepage    = "https://github.com/iamwhil/graph19"
  spec.summary     = "First component"
  spec.description = "Component that meshes migrations and utilizes concerns."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.0.beta3"

  spec.add_development_dependency "pg"
  spec.add_development_dependency "rspec-rails"
end
