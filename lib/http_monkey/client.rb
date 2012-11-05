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
      response = HTTPI.request(method, request, net_adapter)

      if (behaviour = @conf.behaviours.find(response.code))
        behaviour.call(self, request, response)
      else
        unknown_behaviour = @conf.behaviours.unknown_behaviour
        unknown_behaviour.call(self, request, response) if unknown_behaviour.respond_to?(:call)
      end
    end

  end

end
