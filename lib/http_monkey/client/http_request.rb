module HttpMonkey

  # Main App middleware
  # Responsible to make HTTP request
  class Client::HttpRequest

    def self.call(env)
      env = Client::Environment.new(env)
      method, request, net_adapter = env['http_monkey.request']

      request.headers = env.http_headers
      request.body = env['rack.input']

      response = HTTPI.request(method, request, net_adapter)
      [response.code, response.headers, response.body]
    end

  end

end
