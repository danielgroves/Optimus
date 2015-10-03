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
      let(:path) { '/some/madeup/path/for/something.jpg' }
      before { get path }

      it 'returns 404' do
        expect(last_response.not_found?).to be true
      end

      it 'returns an empty body' do
        expect(last_response.body).to eql('')
      end
    end

    context 'given a valid path' do
      let(:path) { '/assets/camera-roll/2015/09/soar/20150926-DSC_0827.jpg' }
      before { get path }

      it 'returns an image content type' do
        expect(last_response.headers['Content-Type']).to eql('image/jpeg')
      end

      it 'returns 200' do
        expect(last_response.ok?).to be true
      end

      it 'has the correct content length' do
        expect(last_response.headers['Content-Length']).to eql '834653'
      end
    end
  end
end
