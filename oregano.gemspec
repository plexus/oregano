# encoding: utf-8

require File.expand_path('../lib/ukulele/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'ukulele'
  gem.version     = Oregano::VERSION
  gem.authors     = [ 'Arne Brasseur' ]
  gem.email       = [ 'arne@arnebrasseur.net' ]
  gem.description = ''
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/plexus/ukulele'
  gem.license     = 'GPL-3'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files = %w[README.md]

  gem.add_runtime_dependency 'inflection'                , '~> 1.0'
  gem.add_runtime_dependency 'concord'                   , '~> 0.1.4'
  gem.add_runtime_dependency 'anima'                     , '~> 0.2.0'
  gem.add_runtime_dependency 'adamantium'                , '~> 0.2.0'
  gem.add_runtime_dependency 'kramdown-metadata-parsers' , '>= 0.9'
  gem.add_runtime_dependency 'hexp-kramdown'             , '>= 0.9'
  gem.add_runtime_dependency 'asset_packer'              , '> 0'

  gem.add_development_dependency 'rake'
end
