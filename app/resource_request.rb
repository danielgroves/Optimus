require 'net/http'
require 'uri'

# Requests a remote resource
class ResourceRequest
  def get(path)
    url = "https://danielgroves.net#{path}"
    uri = URI.parse url

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new uri.request_uri

    response = http.request request
    response
  end
end
