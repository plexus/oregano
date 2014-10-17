class SimpleStyle4 < Ukulele::Template
  LOCATION = Pathname(__FILE__).dirname

  def tangle(body, metadata)
    index_page = Hexp.parse(LOCATION.join('public', 'index.html').read)

    index_page
      .replace('h1') {|title| title.set_children(metadata['title']) }
      .replace('#content') {|main| body }
  end
end
