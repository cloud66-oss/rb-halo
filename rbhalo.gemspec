
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rbhalo/version"

Gem::Specification.new do |spec|
  spec.name          = "rb-halo"
  spec.version       = RbHalo::VERSION
  spec.authors       = ["Khash Sajadi"]
  spec.email         = ["khash@cloud66.com"]

  spec.summary       = "HALO client gem"
  spec.description   = "HALO is a logging framework. This is a Ruby client gem for it"
  spec.homepage      = "https://github.com/cloud66-oss/rb-halo"

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
