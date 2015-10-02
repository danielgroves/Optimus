# Rack application for on-the-fly image optimisation.
class Optimus
  def call(env)
    req = Rack::Request.new(env)

    [200, {}, [req.path_info]]
  end
end
