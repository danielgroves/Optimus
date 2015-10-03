require 'rspec'
require 'rack/test'
require 'rmagick'

require_relative '../app/image'

describe Image do
  let(:path) { 'test.jpg' }
  let(:magick) { Magick::Image.read(path).first }

  context 'image loading' do
    before { @image = Image.new File.open(path, 'rb').read }

    it 'be the same as before' do
      expect(@image.finish).to eql magick.to_blob
    end
  end

  context 'resize image' do
    before(:each) do
      @image = Image.new File.open(path, 'rb').read
    end

    it 'is 500px wide' do
      @image.dimensions width: 500

      verify_output = Magick::Image.from_blob @image.finish
      expect(verify_output.first.columns).to eql 500
    end

    it 'is 700px high' do
      @image.dimensions height: 700

      verify_output = Magick::Image.from_blob @image.finish
      expect(verify_output.first.rows).to eql 700
    end

    it 'is 300 by 200' do
      @image.dimensions width: 300, height: 200

      verify_output = Magick::Image.from_blob @image.finish
      expect(verify_output.first.columns).to eql 300
      expect(verify_output.first.rows).to eql 200
    end
  end
end
