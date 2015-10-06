require 'yaml'

# Loads the configuration from YAML
class Config
  def initialize
    file_name = 'optimus.yml'
    @data = YAML.load(open(file_name)) if File.exist?(file_name)
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
