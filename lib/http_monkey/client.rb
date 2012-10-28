module HttpMonkey

  class ClientAttributes

    def initialize
      net_adapter(:net_http)  #default adapter
    end

    def net_adapter(adapter = nil)
      @net_adapter = adapter unless adapter.nil?
      @net_adapter
    end

  end

  class Client

    def initialize
      @attrs = ClientAttributes.new
    end

    def net_adapter
      @attrs.net_adapter
    end

    def configure(&block)
      @attrs.instance_eval(&block) if block_given?
      self
    end

    def http_request(method, request)
      HTTPI.request(method, request, net_adapter)
    end

  end

end
