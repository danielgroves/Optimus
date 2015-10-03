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

    let(:original_ratio) { calculate_ratio magick.rows, magick.columns }

    it 'is 500px wide' do
      @image.dimensions width: 500

      verify_output = Magick::Image.from_blob(@image.finish).first
      expect(verify_output.columns).to eql 500
    end

    it 'is 700px high' do
      @image.dimensions height: 700

      verify_output = Magick::Image.from_blob(@image.finish).first
      expect(verify_output.rows).to eql 700
    end

    it 'is 300 by 200' do
      @image.dimensions width: 300, height: 200

      verify_output = Magick::Image.from_blob(@image.finish).first
      expect(verify_output.columns).to eql 300
      expect(verify_output.rows).to eql 200
    end

    it 'is same aspect ratio after width change' do
      @image.dimensions width: 400, maintain_aspect: true
      complete_image = Magick::Image.from_blob(@image.finish).first
      new_ratio = calculate_ratio complete_image.rows, complete_image.columns

      expect(new_ratio).to eql original_ratio
      expect(complete_image.columns).to eql 400
    end

    it 'is same aspect ratio after height change' do
      @image.dimensions height: 300, maintain_aspect: true
      complete_image = Magick::Image.from_blob(@image.finish).first
      new_ratio = calculate_ratio complete_image.rows, complete_image.columns

      expect(new_ratio).to eql original_ratio
      expect(complete_image.rows).to eql 300
    end

    it 'is different aspect ratio after width change' do
      @image.dimensions width: 300, maintain_aspect: false
      complete_image = Magick::Image.from_blob(@image.finish).first
      new_ratio = calculate_ratio complete_image.rows, complete_image.columns

      expect(new_ratio).to_not eql original_ratio
      expect(complete_image.columns).to eql 300
      expect(complete_image.rows).to eql magick.rows
    end

    it 'is different aspect ratio after height change' do
      @image.dimensions height: 300, maintain_aspect: false
      complete_image = Magick::Image.from_blob(@image.finish).first
      new_ratio = calculate_ratio complete_image.rows, complete_image.columns

      expect(new_ratio).to_not eql original_ratio
      expect(complete_image.rows).to eql 300
      expect(complete_image.columns).to eql magick.columns
    end
  end
end

def calculate_ratio(one, two)
  (1 / (one.to_f / two.to_f)).round(2)
end
