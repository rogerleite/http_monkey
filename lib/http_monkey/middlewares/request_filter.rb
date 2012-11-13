module HttpMonkey::Middlewares

  # Intercept all requests
  #
  # Example
  #
  #   HttpMonkey.configure do
  #     middlewares.use HttpMonkey::Middlewares::RequestFilter do |env, request|
  #       # HttpMonkey::Client::Environment, hash rack on steroids
  #       # You can use "snaky" methods like:
  #       # env.http_headers  # => {"Content-Type" => "text/html"}
  #       # env.add_http_header("X-Custom" => "custom")
  #
  #       # HTTPI::Request, you can set proxy, timeouts, authentication etc.
  #       # req.proxy = "http://example.com"
  #     end
  #   end
  #
  class RequestFilter

    def initialize(app, &block)
      @app = app
      @block = (block || lambda {|env, req| })
    end

    def call(env)
      @block.call(env, env.monkey_request)
      @app.call(env)
    end

  end

end
