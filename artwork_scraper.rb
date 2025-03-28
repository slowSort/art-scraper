require 'nokogiri'
require 'json'
require 'base64'
require 'cgi'

class ArtworkScraper
  def initialize(html_content)
    @document = Nokogiri::HTML(html_content)
    @img_dict = extract_base64_image_data(@document)
  end

  def scrape
    { "artworks" => extract_artworks(@document) }
  end

  private

  def extract_base64_image_data(document)
    script_contents = document.css('script')
      .map(&:inner_html)
      .select { |code| code.include?('_setImagesSrc') }

    image_setter_calls = script_contents
      .flat_map { |code| code.split(/\}\)\(\);\s*(?=\()/) }
      .select { |block| block.include?('_setImagesSrc') }

    image_setter_calls.each_with_object({}) do |block, img_dict|
      base64_data = block[/var\s*s\s*=\s*'([^']*)'/, 1]
      image_id = block[/var\s*ii\s*=\s*\['([^']*)'\]/, 1]

      if base64_data && image_id
        # Convert escaped hex sequences to their actual characters.
        # Bit hacky but ran low on time!
        base64_data = base64_data.gsub(/\\x([0-9a-fA-F]{2})/) { |m| m[2..3].hex.chr }
        img_dict[image_id] = base64_data
      end
    end
  end

  def extract_artworks(document)
    document.css('div[data-attrid="kc:/visual_art/visual_artist:works"]')
      .css('.iELo6')
      .map do |artwork_item|
        name = artwork_item.css('.pgNMRc').text.strip
        extension_text = artwork_item.css('.cxzHyb').text.strip
        extensions = extension_text.empty? ? nil : [extension_text]

        link = artwork_item.css('a').attr('href')&.value
        link = "https://www.google.com#{link}" if link && link.start_with?('/')

        img_node = artwork_item.css('img').first
        img_id = img_node&.attr('id')
        image = img_id ? @img_dict[img_id] : img_node&.attr('data-src')

        {
          "name" => name,
          "extensions" => extensions,
          "link" => link,
          "image" => image
        }.tap { |hash| hash.delete("extensions") unless extensions }
      end
      .compact
  end
end