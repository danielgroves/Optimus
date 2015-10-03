require_relative 'resource_request'
require_relative 'image'

# Rack application for on-the-fly image optimisation.
class Optimus
  # rubocop:disable Metrics/AbcSize

  def call(env)
    request = Rack::Request.new env

    resource = ResourceRequest.new.get request.path_info

    response = Rack::Response.new

    if resource.code == '200'
      image = Image.new resource.body
      response.write image.finish
      response['Content-Type'] = 'image/jpeg'
    end

    response.status = resource.code
    response.finish
  end
end
