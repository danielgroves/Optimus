require 'rspec'
require 'rack/test'

require_relative '../app/optimus'

describe Optimus do
  include Rack::Test::Methods

  def app
    Optimus.new
  end

  describe '/' do
    context 'given an invalid path' do
      path = '/some/madeup/path/for/something.jpg'

      it 'returns 404' do
        get path
        expect(last_response.not_found?).to be true
      end
    end

    context 'given a valid path' do
      path = '/assets/camera-roll/2015/09/solo/20150829-DSC_0382-HDR.jpg'

      it 'returns an image content type' do
        get path
        expect(last_response.headers['Content-Type']).to eql('image/jpeg')
      end

      it 'returns 200' do
        get path
        expect(last_response.ok?).to be true
      end

      it 'has the correct content length' do
        get path
        expect(last_response.headers['Content-Length']).to eql '1082900'
      end
    end
  end
end
