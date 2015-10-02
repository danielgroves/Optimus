require_relative 'resource_request'

# Rack application for on-the-fly image optimisation.
class Optimus
  def call(env)
    request = Rack::Request.new env

    resource = ResourceRequest.new().get request.path_info

    response = Rack::Response.new
    response.write resource.body
    response['Content-Type'] = 'image/jpeg'
    response.status = resource.code

    response.finish
  end
end
