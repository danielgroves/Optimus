require_relative 'resource_request'
require_relative 'image'

# Rack application for on-the-fly image optimisation.
class Optimus
  def call(env)
    request = Rack::Request.new env

    resource = ResourceRequest.new.get request.path_info
    image = Image.new resource.body

    response = Rack::Response.new
    response.write image.finish
    response['Content-Type'] = 'image/jpeg'
    response.status = resource.code

    response.finish
  end
end
