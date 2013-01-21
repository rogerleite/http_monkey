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
      client = self
      env = Client::EnvironmentBuilder.new(self, method, request).to_env

      begin
        code, headers, body = @conf.middlewares.execute(Middlewares::HttpRequest, env)
        body.close if body.respond_to?(:close)  # close when is a Rack::BodyProxy
      rescue => error
        raise unless @conf.behaviours.error_behaviour
        return @conf.behaviours.error_behaviour.call(client, request, error)
      end

      response = Client::Response.new(code, headers, body)
      @conf.behaviours.execute(response.code) do |behaviour|
        behaviour.call(client, request, response)
      end
    end

  end

end
