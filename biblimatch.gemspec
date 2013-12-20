# -*- encoding: utf-8 -*-
require File.expand_path('../lib/biblimatch/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sean Mackesey"]
  gem.email         = ["s.mackesey@gmail.com"]
  gem.description   = %q{Takes bibliographic data in various formats, matches and maps against other databases and formats}
  gem.summary       = %q{A summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "biblimatch"
  gem.require_paths = ["lib"]
  gem.version       = Biblimatch::VERSION

  gem.add_runtime_dependency 'highline'
  gem.add_runtime_dependency 'bio'

end
