require 'rspec'
require 'rspec_boolean'
require 'rack/test'

require_relative '../app/config'

describe Config do
  let(:valid_config_path) { 'optimus.example.yml' }
  let(:invalid_config_path) { 'optimus.nonexistant.yml' }

  context 'given a valid path' do
    before { @configuration = Config.new(valid_config_path) }

    it 'should have a string origin' do
      expect(@configuration[:origin].is_a? String).to be true
    end

    it 'should have a ssl hash' do
      expect(@configuration[:ssl].is_a? Hash).to be true
    end

    it 'should have a ssl verify boolean' do
      expect(@configuration[:ssl][:verify]).to be_boolean
    end

    it 'should have a ssl use boolean' do
      expect(@configuration[:ssl][:use]).to be_boolean
    end
  end
end
