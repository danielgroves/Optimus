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

      it 'returns the path' do
        get path
        expect(last_response.body).to eql(path)
      end

      it 'returns 200' do
        get path
        expect last_response.ok?
      end
    end
  end
end
