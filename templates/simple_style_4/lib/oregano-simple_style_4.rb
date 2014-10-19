Oregano::Template.new(:simple_style_4) do
  page_template :index do |body, metadata|
    replace('h1')       { |title| title.content(metadata['title']) }
    replace('#content') { |main| body }
  end
end
