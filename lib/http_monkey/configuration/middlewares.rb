module HttpMonkey

  # Heavily inspired on Rack::Builder (http://rack.rubyforge.org/doc/Rack/Builder.html)
  class Configuration::Middlewares

    def initialize
      @chain = []
    end

    def initialize_copy(source)
      super
      @chain = @chain.clone
    end

    def use(middleware, *args, &block)
      @chain << lambda { |app| middleware.new(app, *args, &block) }
      self
    end

    def execute(app, env)
      stacked_middleware = @chain.reverse.inject(app) do |app, middle|
        middle.call(app)
      end
      stacked_middleware.call(env)
    end

  end

end
