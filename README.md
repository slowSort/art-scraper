# Google Artwork Scraper

A Ruby implementation of a scraper for Google's artwork carousel.

## Setup

1. Install dependencies:
```bash
bundle install
```

2. Make the scraper executable:
```bash
chmod +x bin/scrape
```

## Usage

Run the scraper with an HTML file:
```bash
./bin/scrape path/to/your/file.html
```

The output will be JSON formatted with the following structure:
```json
{
  "artworks": [
    {
      "name": "Artwork Name",
      "extensions": ["1888"],
      "link": "https://www.google.com/...",
      "image": "data:image/jpeg;base64,..."
    }
  ]
}
```

## Testing

Run the test suite:
```bash
bundle exec rspec
```

# Extract Van Gogh Paintings Code Challenge

Goal is to extract a list of Van Gogh paintings from the attached Google search results page.

![Van Gogh paintings](https://github.com/serpapi/code-challenge/blob/master/files/van-gogh-paintings.png?raw=true "Van Gogh paintings")

## Instructions

This is already fully supported on SerpApi. ([relevant test], [html file], [sample json], and [expected array].)

Extract the painting `name`, `extensions` array (date), and Google `link` in an array.

[relevant test]: https://github.com/serpapi/test-knowledge-graph-desktop/blob/master/spec/knowledge_graph_claude_monet_paintings_spec.rb
[sample json]: https://raw.githubusercontent.com/serpapi/code-challenge/master/files/van-gogh-paintings.json
[html file]: https://raw.githubusercontent.com/serpapi/code-challenge/master/files/van-gogh-paintings.html
[expected array]: https://raw.githubusercontent.com/serpapi/code-challenge/master/files/expected-array.json

Test against 2 other similar result pages to make sure it works against different layouts. (Pages that contain the same kind of carrousel. Don't necessarily have to be paintings.)
