require 'rspec'
require 'rspec_boolean'
require 'rack/test'

require_relative '../app/config'

describe Config do
  let(:valid_config_path) { 'optimus.example.yml' }
  let(:invalid_config_path) { 'optimus.nonexistant.yml' }

  context 'given a valid path' do
    let(:configuration) { described_class.new(valid_config_path) }

    it 'have a string origin' do
      expect(configuration[:origin].is_a? String).to be true
    end

    it 'have a ssl hash' do
      expect(configuration[:ssl].is_a? Hash).to be true
    end

    it 'have a ssl verify boolean' do
      expect(configuration[:ssl][:verify]).to be_boolean
    end

    it 'have a ssl use boolean' do
      expect(configuration[:ssl][:use]).to be_boolean
    end

    it 'have a limits hash' do
      expect(configuration[:limits].is_a? Hash).to be true
    end

    it 'have a maximum width int' do
      expect(configuration[:limits][:width].is_a? Integer).to be true
    end

    it 'have a maximum height int' do
      expect(configuration[:limits][:height].is_a? Integer).to be true
    end
  end
end
