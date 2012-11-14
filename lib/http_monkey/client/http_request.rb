module HttpMonkey

  # Main App middleware
  # Responsible to make HTTP request
  class Client::HttpRequest

    def self.call(env)
      env = Client::Environment.new(env) unless env.is_a?(Client::Environment)
      method, request, client = env['http_monkey.request']

      request.headers = env.http_headers
      request.body = env['rack.input']

      response = HTTPI.request(method, request, client.net_adapter)
      [response.code, response.headers, response.body]
    end

  end

end
