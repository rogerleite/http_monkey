module HttpMonkey

  class Client

    def initialize
      @conf = Configuration.new
    end

    def initialize_copy(source)
      super
      @conf = @conf.clone
    end

    def at(url)
      HttpMonkey::EntryPoint.new(self, url)
    end

    def net_adapter
      @conf.net_adapter
    end

    def configure(&block)
      @conf.instance_eval(&block) if block_given?
      self
    end

    def http_request(method, request)
      env = Client::EnvironmentBuilder.new(self, method, request).to_env
      rack_response = @conf.middlewares.execute(Client::HttpRequest, env) # rack response [code, headers, body]
      response = HTTPI::Response.new(rack_response[0], rack_response[1], rack_response[2])

      if (behaviour = @conf.behaviours.find(response.code))
        behaviour.call(self, request, response)
      else
        unknown_behaviour = @conf.behaviours.unknown_behaviour
        unknown_behaviour.call(self, request, response) if unknown_behaviour.respond_to?(:call)
      end
    end

  end

  # Main App middleware
  # Responsible to make HTTP request
  class Client::HttpRequest

    def self.call(env)
      method, request, net_adapter = env['http_monkey.request']
      request.headers = Client::Environment.new(env).http_headers

      response = HTTPI.request(method, request, net_adapter)
      [response.code, response.headers, response.body]
    end

  end

end
