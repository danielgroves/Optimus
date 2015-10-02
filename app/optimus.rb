# Rack application for on-the-fly image optimisation.
class Optimus
  def call(env)
    request = Rack::Request.new env

    response = Rack::Response.new
    response.write request.path_info
    response['Content-Type'] = 'image/jpeg'
    response.status = 200

    response.finish
  end
end
