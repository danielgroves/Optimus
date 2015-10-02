class Optimus
  def call(env)
    req = Rack::Request.new(env)

    [200, {}, [req.path_info]]
  end
end
