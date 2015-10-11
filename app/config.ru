require_relative 'optimus'
require_relative 'config'

configuration = Config.new

if configuration[:sentry][:dsn].nil?
  require 'raven'

  Raven.configure do |config|
    config.dsn = configuration[:sentry][:dsn]
  end

  use Raven::Rack
end

use Rack::Reloader
run Optimus.new
