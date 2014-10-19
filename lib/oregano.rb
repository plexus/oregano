require 'pathname'
require 'delegate'
require 'kramdown'
require 'hexp-kramdown'
require 'yaml'
require 'asset_packer'
require 'adamantium'

module Oregano
  ROOT = Pathname(__FILE__).dirname.parent
  TEMPLATES = {}
  DEFAULT_METADATA = {'page' => 'index'}

  class Site
    include Adamantium

    attr_reader :name, :site_dir, :build_dir

    def initialize(name, site_dir, build_dir)
      @name = name
      @site_dir = site_dir
      @build_dir = build_dir
    end

    def site_yml_location
      site_dir.join('site.yml')
    end

    def site_metadata
      YAML.load(site_yml_location.read)
    end

    def template_name
      site_metadata['template']
    end

    def template
      require "oregano-#{template_name}"
      TEMPLATES[template_name.to_sym]
    end

    def build
      Pathname.glob(site_dir.join "**/*.md").each do |md|
        pagename = md.basename(md.extname).to_s
        doc      = Kramdown::Document.new(md.read, input: 'MetadataGFM')
        metadata = DEFAULT_METADATA.merge(site_metadata.merge(doc.root.metadata))
        body     = Hexp::Kramdown.convert(doc)

        destination = build_dir.join(pagename + '.html')

        page_template = template.page_template(metadata['page'].to_sym)
        output = page_template.tangle(body, metadata)

        pack_assets = AssetPacker::Processor::Local.new(
          "file://#{page_template.location}",
          build_dir.join('assets'),
          destination
        )

        output = pack_assets.call(output)

        destination.write(output.to_html)
      end
    end
  end

  class Template
    attr_reader :name

    def initialize(name, &block)
      @name = name
      @page_templates = {}
      instance_eval(&block)
      TEMPLATES[name.to_sym] = self
    end

    def location
      Pathname(Gem.loaded_specs["oregano-#{name}"].full_gem_path)
    end

    def page_template(name, &transforms)
      if block_given?
        @page_templates[name] = PageTemplate.new(name, location, &transforms)
      else
        @page_templates[name]
      end
    end
  end

  class PageTemplate
    attr_reader :name, :location, :transforms

    def initialize(name, location, &transforms)
      @name = name
      @location = location.join('public', "#{name}.html")
      @transforms = transforms
    end

    def load_dom
      Hexp.parse(location.read)
    end

    def tangle(body, metadata)
      StatefulTransform.new(load_dom).call(body, metadata, transforms)
    end
  end

  class StatefulTransform
    def initialize(dom)
      @dom = dom
    end

    def call(body, metadata, transforms)
      instance_exec(body, metadata, &transforms)
    end

    def replace(selector, &rule)
      @dom = @dom.replace(selector, &rule)
    end
  end
end
