require 'rspec'
require_relative '../lib/artwork_scraper'

RSpec.describe ArtworkScraper do
  let(:html_content) { File.read('./files/van-gogh-paintings.html') }
  let(:scraper) { ArtworkScraper.new(html_content) }
  let(:result) { scraper.scrape }

  describe '#scrape' do
    it 'returns an object with artworks property' do
      expect(result).to be_a(Hash)
      expect(result).to have_key('artworks')
      expect(result['artworks']).to be_a(Array)
    end

    describe 'artwork structure' do
      it 'each artwork has required attributes' do
        result['artworks'].each do |artwork|
          expect(artwork).to include('name', 'link', 'image')
        end
      end

      it 'name is a non-empty string' do
        result['artworks'].each do |artwork|
          expect(artwork['name']).to be_a(String)
          expect(artwork['name']).not_to be_empty
        end
      end

      it 'link is a valid Google URL' do
        result['artworks'].each do |artwork|
          expect(artwork['link']).to be_a(String)
          expect(artwork['link']).to start_with('https://www.google.com')
        end
      end

      it 'image is either a base64 string, a Google image URL, or nil' do
        result['artworks'].each do |artwork|
          image = artwork['image']
          expect(image).to be_a(String).or(be_nil)

          is_base64 = image&.start_with?('data:image/') && image&.include?(';base64,')
          is_google_image = image&.start_with?('https://encrypted-tbn')

          expect(is_base64 || is_google_image || image.nil?).to be true
        end
      end

      it 'extensions is an array of non-empty strings when present' do
        result['artworks'].each do |artwork|
          extensions = artwork['extensions']
          next unless extensions

          expect(extensions).to be_a(Array)
          expect(extensions).to all(be_a(String))
          expect(extensions).to all(satisfy { |ext| !ext.empty? })
        end
      end

      it 'maintains correct field order: name, extensions (if present), link, image' do
        result['artworks'].each do |artwork|
          keys = artwork.keys
          expected_order = ['name']
          expected_order << 'extensions' if artwork['extensions']
          expected_order.concat(['link', 'image'])

          expect(keys).to eq(expected_order)
        end
      end
    end

    describe 'specific artwork content' do
      it 'includes "The Starry Night" as the first artwork' do
        expect(result['artworks'].first['name']).to eq('The Starry Night')
      end

      it 'includes "Van Gogh self-portrait" as the second artwork' do
        expect(result['artworks'][1]['name']).to eq('Van Gogh self-portrait')
      end
    end
  end
end