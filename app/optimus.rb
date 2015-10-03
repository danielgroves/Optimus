require_relative 'resource_request'
require_relative 'image'

# Rack application for on-the-fly image optimisation.
class Optimus
  def call(env)
    request = Rack::Request.new env
    response = process_request request
    response.finish
  end

  private

  def process_request(rack_request)
    remote_resource = ResourceRequest.new.get rack_request.path_info

    if remote_resource.code == '200'
      rack_request.params.store('maintain_aspect', true) unless rack_request.params.key? 'maintain_aspect'
      response = process_image remote_resource.body, rack_request
    else
      response = Rack::Response.new
      response.status = 404
    end

    response
  end

  def process_image(image_data, request)
    image = Image.new image_data

    if request.params.key?('width') && request.params.key?('height')
      image.dimensions width: request.params['width'].to_i,
                       height: request.params['height'].to_i,
                       maintain_aspect: request.params['maintain_aspect']
    elsif request.params.key? 'width'
      image.dimensions width: request.params['width'].to_i,
                       maintain_aspect: request.params['maintain_aspect']
    elsif request.params.key? 'height'
      image.dimensions height: request.params['height'].to_i,
                       maintain_aspect: request.params['maintain_aspect']
    end

    build_response image
  end

  def build_response(image)
    response = Rack::Response.new
    response.write image.finish
    response.status = image.modified ? 201 : 200
    response['Content-Type'] = 'image/jpeg'

    response
  end
end
