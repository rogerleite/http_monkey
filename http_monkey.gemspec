# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http_monkey/version'

Gem::Specification.new do |gem|
  gem.name          = "http_monkey"
  gem.version       = HttpMonkey::VERSION
  gem.authors       = ["Roger Leite"]
  gem.email         = ["roger.barreto@gmail.com"]
  gem.summary       = 'Slim HTTP client powered by middlewares and support to many adapters.'
  gem.description   = <<-DESC
    Slim HTTP client with fluent interface. Supports many adapters, HTTPClient, Curb,
    EM-HTTP-Request and Ruby net/http by default. Powered by middlewares, like Rack.
  DESC
  gem.homepage      = "https://github.com/rogerleite/http_monkey"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "rack"
  gem.add_runtime_dependency "httpi", "~> 2"
  gem.add_runtime_dependency "http_objects", "~> 0"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest", "~> 3"
  gem.add_development_dependency "minitest-reporters", "~> 0.7.0"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "minion_server"
end
