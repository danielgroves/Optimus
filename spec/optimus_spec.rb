require 'rspec'
require 'rack/test'

require_relative '../app/optimus'

describe Optimus do
  include Rack::Test::Methods

  def app
    Optimus.new
  end

  describe '/' do
    context 'given a path' do
      path = '/fred/lemons/bitches'

      it 'it returns an image content type' do
        get path
        expect(last_response.headers["Content-Type"]).to eql('image/jpeg')
      end

      it 'returns 200' do
        get path
        expect last_response.ok?
      end
    end
  end
end
