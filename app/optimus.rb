require_relative 'resource_request'
require_relative 'image'

# Rack application for on-the-fly image optimisation.
class Optimus
  # rubocop:disable Metrics/AbcSize

  def call(env)
    request = Rack::Request.new env
    remote_resource = ResourceRequest.new.get request.path_info

    response = Rack::Response.new

    if remote_resource.code == '200'
      image = Image.new remote_resource.body

      if request.params.key?('width') && request.params.key?('height')
        image.dimensions width: request.params['width'].to_i,
                         height: request.params['height'].to_i
      elsif request.params.key? 'width'
        image.dimensions width: request.params['width'].to_i
      elsif request.params.key? 'height'
        image.dimensions height: request.params['height'].to_i
      end

      response.write image.finish
      response.status = image.modified ? 201 : 200
      response['Content-Type'] = 'image/jpeg'
    else
      response.status = 404
    end

    response.finish
  end
end
