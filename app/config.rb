require 'yaml'

# Loads the configuration from YAML
class Config
  def initialize(config = 'optimus.yml')
    @data = YAML.load(open(config)) if File.exist?(config)
  end

  def [](key)
    env = "OPTIMUS_#{key.to_s.upcase}"
    @data[key] = ENV[env] unless ENV[env].nil?
    fail("You must configure #{key} before loading.") unless @data.key? key
    @data[key]
  end

  def []=(key, value)
    @data[key] = value
  end
end
