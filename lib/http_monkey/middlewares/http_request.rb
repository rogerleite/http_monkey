module HttpMonkey::Middlewares

  # Main App middleware
  # Responsible to make HTTP request
  class HttpRequest

    def self.call(env)
      unless env.is_a?(HttpMonkey::Client::Environment)
        env = HttpMonkey::Client::Environment.new(env)
      end
      _, request, client = env['http_monkey.request']

      method = env.request_method
      request.url = env.uri
      request.headers = env.http_headers
      request.body = env['rack.input']

      response = HTTPI.request(method, request, client.net_adapter)
      [response.code, response.headers, response.body]
    end

  end

end
