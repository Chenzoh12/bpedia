module ApplicationHelper
    def render_markdown(text)
        renderer = Redcarpet::Render::HTML.new()
        markdown = Redcarpet::Markdown.new(renderer, extensions = {

        })
        
        markdown.render(text).html_safe if text
    end
end
