require_relative 'optimus'

use Rack::Reloader
run Optimus.new
