---
title: 'Slippery | The Best Slides are Slippery Slides'
---

# Slippery

Marries the flexible [Kramdown](https://kramdown.rubyforge.org) parser for Markdown with the flexibility of DOM manipulation with [Hexp](https://github.com/plexus/hexp) to generate HTML slides backed by either Reveal.js or Impress.js.

Because Slippery slides are the best slides.

## How to use

Create a markdown file, say `presentation.md`, that will be the source of your presentation. use `---` to separate slides.

In the same directory, create a Rakefile, the most basic form is :

```ruby
require 'slippery'

Slippery::RakeTasks.new
```

Slippery will detect and markdown files in the current directory, and generate rake tasks for them.

```
rake slippery:build               # build all
rake slippery:build:presentation  # build presentation
```


You can use a block to configure Slippery:

```ruby
require 'slippery'

Slippery::RakeTasks.new do |s|
  s.options = {
    type: :reveal_js,
    theme: 'beige',
    controls: false,
    backgroundTransition: 'slide',
    history: true,
    plugins: [:notes]
  }

  s.processor 'head' do |head|
    head <<= H[:title, 'Web Services, Past Present Future']
  end

  s.include_assets
end
```

After converting your presentation from Markdown, you can use Hexp to perform transformations on the result. This is what happens with the `processor`, you pass it a CSS selector, each matching element gets passed into the block, and replaced by whatever the block returns. See the [Hexp](http://github.com/plexus/hexp) DSL for details.

You can also add built-in or custom processors directly

```ruby
Slippery::RakeTasks.new do |s|
  s.processors << Slippery::Processors::GraphvizDot.new('.dot')
end
```

The rake task also has a few DSL methods for common use cases

```ruby
Slippery::RakeTasks.new do |s|
  s.title "Functional Programming in Ruby"
  s.include_assets
  s.add_highlighting
end
```

* `title` Configure the title used in the HTML `&lt;title&gt;` tag
* `include_assets` Download/copy all js/css/images to the `assets` directory, and adjust the URIs in the document accordingly
* `add_highlighting` Add Highlight.js. Takes the style and version as arguments, e.g. `add_highlighting(:default, '0.8.0')`

## Processors

These are defined in the `Slippery::Processors` namespace.

### GraphvizDot

The "Dot" language is a DSL (domain specific language) for describing graphs. Using the `GraphvizDot` processor, you can turn "dot" fragments into inline SVG graphics. This requires the `dot` command line utility to be available on your system. Look for a package named `graphviz`.

In your presentation :

    ````dot
    graph dependencies {
      node[shape=circle color=blue]
      edge[color=black penwidth=3]

      slippery[fontcolor=red];

      slippery -> hexp -> equalizer;
      slippery -> kramdown;
      hexp -> ice_nine;
    }
    ````

In the Rakefile

```ruby
Slippery::RakeTasks.new do |s|
  s.processors << Slippery::Processors::GraphvizDot.new('.dot')
  s.processors << Slippery::Processors::SelfContained
end
```
