require_relative "lib/auth_master/version"

Gem::Specification.new do |spec|
  spec.name        = "auth_master"
  spec.version     = AuthMaster::VERSION
  spec.authors     = [ "vickodin" ]
  spec.email       = [ "vick.orel@gmail.com" ]
  spec.homepage    = "https://github.com/vickodin/auth_master"
  spec.summary     = "Authentication engine for projects built with Rails (Ruby on Rails)"
  spec.description = "Authentication Engine"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/vickodin/auth_master"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.2"
  spec.add_dependency "token_guard"
end
