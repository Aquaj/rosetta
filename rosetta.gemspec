
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rosetta/version"

Gem::Specification.new do |spec|
  spec.name          = "rosetta-stone"
  spec.version       = Rosetta::VERSION
  spec.authors       = ["Jérémie Bonal"]
  spec.email         = ["jeremie.bonal@gmail.com"]

  spec.summary       = %q{Small library to allow for conversions between formats.}
  spec.homepage      = "https://github.com/Aquaj/rosetta-stone"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
