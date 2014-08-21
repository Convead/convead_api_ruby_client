# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'convead/version'

Gem::Specification.new do |spec|
  spec.name          = 'convead_client'
  spec.version       = Convead::VERSION
  spec.authors       = ['Babur Usenakunov']
  spec.email         = ['hello@convead.io']
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = 'https://github.com/Convead/convead_api_ruby_client'
  spec.license       = 'MIT'

  spec.files = %w[LICENSE.txt README.md Rakefile convead_client.gemspec]
  spec.files += Dir.glob('lib/**/*.rb')
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.0'
end
