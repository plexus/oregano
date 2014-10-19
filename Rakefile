$:.unshift 'lib'

require 'oregano'
require 'hexp-kramdown'
require 'rubygems/package_task'

BUILD_DIR = Oregano::ROOT.join('build')
SITES_DIR = Oregano::ROOT.join('sites')

SITES = SITES_DIR.children.map(&:basename).map(&:to_s)

SITES.each do |site_name|
  desc "build #{site_name}"
  task site_name do
    site_dir  = SITES_DIR.join(site_name)
    build_dir = BUILD_DIR.join(site_name)
    BUILD_DIR.mkdir unless BUILD_DIR.exist?
    build_dir.mkdir unless build_dir.exist?

    Oregano::Site.new(site_name, site_dir, build_dir).build
  end
end

Gem::PackageTask.new(Gem::Specification.load("oregano.gemspec")).define

desc "Push gem to rubygems.org"
task :push => "gem" do
  sh "git tag v#{Oregano::VERSION}"
  sh "git push --tags"
  sh "gem push pkg/oregano-#{Oregano::VERSION}.gem"
end
