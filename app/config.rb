require 'yaml'

# Loads the configuration from YAML
class Config
  def initialize(config = 'optimus.yml')
    @data = {
      origin: 'https://danielgroves.net',
      ssl: {
        verify: true,
        use: true
      },
      limits: {
        width: 2500,
        height: 2500
      },
      sentry_dsn: nil
    }

    @data.merge! YAML.load(open(config)) if File.exist?(config)
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
