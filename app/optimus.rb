require_relative 'resource_request'
require_relative 'image'

# Rack application for on-the-fly image optimisation.
class Optimus
  # rubocop:disable Metrics/AbcSize

  def call(env)
    incoming_request = Rack::Request.new env
    remote_resource = ResourceRequest.new.get incoming_request.path_info

    response = Rack::Response.new

    if remote_resource.code == '200'
      image = Image.new remote_resource.body
      response.write image.finish
      response['Content-Type'] = 'image/jpeg'
    end

    response.status = remote_resource.code
    response.finish
  end
end
