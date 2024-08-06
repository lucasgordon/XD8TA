module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    html = markdown.render(text)
    html.gsub(/<p>/, '<p style="margin-bottom: 0px;">').html_safe
  end
end
