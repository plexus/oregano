$:.unshift 'lib'

require 'ukulele'
require 'hexp-kramdown'

load Ukulele::ROOT.join('templates/simple_style_4/template.rb')

BUILD_DIR = Ukulele::ROOT.join('build')
SITES_DIR = Ukulele::ROOT.join('sites')

SITES = SITES_DIR.children.map(&:basename).map(&:to_s)

class AssetPacker::Processor::Local
  class MungeScript < self
    def call(doc)
      doc.replace('script[src]') do |script|
        href = script[:src]
        script.attr(:src, save_asset(href, 'js', &extract_pseudo_links(href)))
      end
    end

    def extract_pseudo_links(base_url)
      ->(content) do
        content.gsub(/href: ?['"]([^'"]*)['"]/) {
          "href: '#{ save_asset(URI.join(full_source_uri, $1), File.extname($1)[1..-1]) }'"
        }
      end
    end

  end
end

task :default do
  SITES.each do |site_name|
    site_dir  = SITES_DIR.join(site_name)
    build_dir = BUILD_DIR.join(site_name)
    BUILD_DIR.mkdir unless BUILD_DIR.exist?
    build_dir.mkdir unless build_dir.exist?
    Pathname.glob(site_dir.join "**/*.md").each do |md|
      pagename = md.basename(md.extname).to_s
      doc = Kramdown::Document.new(md.read, input: 'MetadataGFM')
      metadata = doc.root.metadata
      body = Hexp::Kramdown.convert(doc)

      destination = build_dir.join(pagename + '.html')

      output = SimpleStyle4.new.tangle(body, metadata)

      args = [
        "file://#{SimpleStyle4::LOCATION.join('public/index.html')}",
        build_dir.join('assets'),
        destination
      ]

      pack_assets = AssetPacker::Processor::Chain.new(
        [
          AssetPacker::Processor::Local::Image.new(*args),
          AssetPacker::Processor::Local::MungeScript.new(*args),
          AssetPacker::Processor::Local::Stylesheet.new(*args)
        ]
      )

      output = pack_assets.call(output)

      destination.write(output.to_html)
    end
  end
end
