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

    def storage
      @conf.storage
    end

    def configure(&block)
      @conf.instance_eval(&block) if block_given?
      self
    end

    def http_request(method, request)
      env = Client::EnvironmentBuilder.new(self, method, request).to_env
      code, headers, body = @conf.middlewares.execute(Middlewares::HttpRequest, env)
      body.close if body.respond_to?(:close)  # close when is a Rack::BodyProxy
      response = HTTPI::Response.new(code, headers, body)

      if (behaviour = @conf.behaviours.find(response.code))
        behaviour.call(self, request, response)
      else
        unknown_behaviour = @conf.behaviours.unknown_behaviour
        unknown_behaviour.call(self, request, response) if unknown_behaviour.respond_to?(:call)
      end
    end

  end

end
