require 'rspec'
require 'rack/test'
require 'rmagick'

require_relative '../app/optimus'

describe Optimus do
  include Rack::Test::Methods

  def app
    Optimus.new
  end

  describe '/' do
    context 'given an invalid path' do
      let(:path) { '/some/madeup/path/for/something.jpg' }
      before { get path }

      it 'return 404' do
        expect(last_response.not_found?).to be true
      end

      it 'return an empty body' do
        expect(last_response.body).to eql('')
      end
    end

    context 'given a valid path' do
      let(:path) { '/assets/camera-roll/2015/09/soar/20150926-DSC_0827.jpg' }
      before { get path }

      it 'return an image content type' do
        expect(last_response.headers['Content-Type']).to eql('image/jpeg')
      end

      it 'return 201' do
        expect(last_response.created?).to be true
      end
    end

    context 'given a valid request, generate a thumbnail which' do
      let(:width) { 500 }
      let(:path) { "/assets/camera-roll/2015/09/soar/20150926-DSC_0827.jpg?width=#{width}" }
      before { get path }
      let(:image) { Magick::Image.from_blob(last_response.body).first }

      it 'returns 201' do
        expect(last_response.created?).to be true
      end

      it 'returns an image content type' do
        expect(last_response.headers['Content-Type']).to eql 'image/jpeg'
      end

      it 'is 500 pixels wide' do
        expect(image.columns).to eql(width)
      end

      it 'maintained aspect ratio' do
        expect(image.rows).to eql 332
      end
    end

    context 'given a valid request, generate a thumbnail which' do
      let(:width) { 500 }
      let(:path) { "/assets/camera-roll/2015/09/soar/20150926-DSC_0827.jpg?width=#{width}&maintain_aspect=false" }
      before { get path }
      let(:image) { Magick::Image.from_blob(last_response.body).first }

      it 'returns 201' do
        expect(last_response.created?).to be true
      end

      it 'returns an image content type' do
        expect(last_response.headers['Content-Type']).to eql 'image/jpeg'
      end

      it 'is 500 pixels wide' do
        expect(image.columns).to eql(width)
      end

      it 'does not maintain its aspect ratio' do
        expect(image.rows).to eql 1330
      end
    end

    context 'given no path' do
      let(:path) { '/' }
      before { get path }

      it 'returns 404' do
        expect(last_response.not_found?).to be true
      end

      it 'has no body' do
        expect(last_response.body).to eql ''
      end
    end

    context 'the configured dimension limits are obayed' do
      it 'is within the limits no parameters' do
        get '/assets/camera-roll/2015/09/soar/20150926-DSC_0827.jpg'

        image = Magick::Image.from_blob(last_response.body).first
        expect(image.columns <= 2500).to be true
        expect(image.rows <= 2500).to be true
      end

      it 'is within the limits given width and height parameters' do
        get '/assets/camera-roll/2015/09/soar/20150926-DSC_0827.jpg?width=5000&height=5000&maintain_aspect=false'

        image = Magick::Image.from_blob(last_response.body).first
        expect(image.columns <= 2500).to be true
        expect(image.rows <= 2500).to be true
      end
    end
  end
end
