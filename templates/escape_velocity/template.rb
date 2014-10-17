class EscapeVelocity < Ukulele::Template
  LOCATION = Pathname(__FILE__).dirname

  def tangle(body, metadata)
    index_page = Hexp.parse(LOCATION.join('public', 'index.html').read)

    index_page
      .replace('#main-wrapper') {|main| body.set_attrs(main.attributes) }
      .replace('title, .title') {|title| title.set_children(metadata['title']) }
  end
end
