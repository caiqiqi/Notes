# Markdown语法

## Syntax highlighting

Code blocks can be taken a step further by adding syntax highlighting. In your fenced block, add an optional language identifier and we'll run it through syntax highlighting. For example, to syntax highlight Ruby code:

```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```

## Links
Visit GitHub!](https://www.github.com)

