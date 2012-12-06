module HttpMonkey

  class Configuration

    def initialize
      net_adapter(:net_http)  #default adapter
      @behaviours = HttpMonkey::Configuration::Behaviours.new
      # behaviour default always return response
      @behaviours.on_unknown { |client, req, response| response }
      @middlewares = HttpMonkey::Configuration::Middlewares.new
      @storage = Hash.new
    end

    def initialize_copy(source)
      super
      @behaviours = @behaviours.clone
      @middlewares = @middlewares.clone
    end

    def net_adapter(adapter = nil)
      @net_adapter = adapter unless adapter.nil?
      @net_adapter
    end

    def behaviours(&block)
      @behaviours.instance_eval(&block) if block_given?
      @behaviours
    end

    def middlewares(&block)
      @middlewares.instance_eval(&block) if block_given?
      @middlewares
    end

    def storage(store = nil)
      @storage = store unless store.nil?
      @storage
    end

  end

end
