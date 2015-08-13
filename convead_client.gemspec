# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'convead_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'convead_client'
  spec.version       = ConveadClient::VERSION
  spec.authors       = ['Babur Usenakunov']
  spec.email         = ['hello@convead.io']
  spec.description   = %q{Rich client for Convead}
  spec.summary       = %q{Rich client for Convead}
  spec.homepage      = 'https://github.com/Convead/convead_api_ruby_client'
  spec.license       = 'MIT'

  spec.files = %w[LICENSE.txt README.md Rakefile convead_client.gemspec]
  spec.files += Dir.glob('lib/**/*.rb')
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty'
  
  spec.add_development_dependency 'bundler', '~> 1.0'
end
