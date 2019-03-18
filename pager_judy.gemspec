
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pager_judy/version"

Gem::Specification.new do |spec|
  spec.name          = "pager_judy"
  spec.version       = PagerJudy::VERSION
  spec.authors       = ["Mike Williams"]
  spec.email         = ["mdub@dogbiscuit.org"]

  spec.summary       = %q{a Ruby client and CLI for PagerDuty}
  spec.homepage      = "https://github.com/mdub/pager_judy"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "clamp", "~> 1.3.0"
  spec.add_runtime_dependency "config_hound", "~> 1.4", ">= 1.4.1"
  spec.add_runtime_dependency "config_mapper", "~> 1.6"
  spec.add_runtime_dependency "console_logger", "~> 1.0"
  spec.add_runtime_dependency "httpi"
  spec.add_runtime_dependency "jmespath"
  spec.add_runtime_dependency "multi_json"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec-pact-matchers", "~> 0.1"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "rubocop", "~> 0.49"
  spec.add_development_dependency "sham_rack"
  spec.add_development_dependency "sinatra"

end
