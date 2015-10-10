require_relative 'resource_request'
require_relative 'image'
require_relative 'config'

# Rack application for on-the-fly image optimisation.
class Optimus
  def initialize
    @config = Config.new
  end

  def call(env)
    request = Rack::Request.new env

    if request.path_info == '/'
      response = Rack::Response.new
      response.status = 404
    else
      response = process_request request
    end

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

    width = smallest_value [image.width, request.params['width'], @config[:limits][:width]]
    height = smallest_value [image.height, request.params['height'], @config[:limits][:height]]

    image.dimensions width: width,
                     height: height,
                     maintain_aspect: request.params['maintain_aspect']

    build_response image
  end

  def build_response(image)
    response = Rack::Response.new
    response.write image.finish
    response.status = 201
    response['Content-Type'] = 'image/jpeg'

    response
  end

  def smallest_value(array)
    # rubocop:disable Style/RescueModifier
    array.map { |x| Integer(x) rescue nil }.compact.min
  end
end
