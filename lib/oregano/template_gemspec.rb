require 'json'
require 'open-uri'
require 'pathname'

module Oregano
  class TemplateGemspec < Gem::Specification

    def initialize(name, file)
      @location = Pathname(file).dirname
      version = find_next_version
      super() do |gem|
        gem.name = "oregano-#{name}"
        gem.version = version
        gem.description = "#{name} template for Oregano"
        gem.summary     = self.description
        gem.license     = 'GPL-3'
        gem.require_paths    = %w[lib]
        gem.files            = `git ls-files`.split($/)
        gem.add_runtime_dependency 'oregano', '> 0'

        yield gem if block_given?
      end
    end

    private

    def gem_data(gem_name)
      JSON.parse(open("https://rubygems.org/api/v1/gems/#{gem_name}.json").read)
    rescue OpenURI::HTTPError => e
      if e.to_s =~ /404/
        {}
      else
        raise
      end
    end

    def find_next_version
      commit, last_touched = `git log -1  --pretty=format:"%h|%ci" #{@location}`.split('|')
      gem = gem_data('oregano-simple_style_4')
      old_version = gem.fetch('version', '')
      old_commit  = gem.fetch('metadata', {})['commit']
      return old_version if commit == old_commit

      new_version = last_touched[/^\d+-\d+-\d+/].gsub('-', '.')
      if new_version == old_version[/^\d+\.\d+\.\d+/]
        new_version += ('.' + (old_version[/^\d+\.\d+\.\d+\.(\d+)/,1].to_i + 1).to_s)
      end

      new_version
    end
  end
end
