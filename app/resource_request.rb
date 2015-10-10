require 'net/http'
require 'uri'
require 'openssl'
require_relative 'config'

# Requests a remote resource
class ResourceRequest
  def initialize
    @config = Config.new
  end

  def get(path)
    url = "#{@config[:origin]}#{path}"
    uri = URI.parse url

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = @config[:ssl][:use]
    http.verify_mode = @config[:ssl][:verify] ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new uri.request_uri

    response = http.request request
    response
  end
end
