module HttpMonkey

  # Heavily inspired on Rack::Builder (http://rack.rubyforge.org/doc/Rack/Builder.html)
  class Configuration::Middlewares

    def initialize
      @chain = []
      @stack_middlewares = nil
    end

    def initialize_copy(source)
      super
      @chain = @chain.clone
      @stack_middlewares = @stack_middlewares.clone if @stack_middlewares
    end

    def use(middleware, *args, &block)
      @chain << lambda { |app| middleware.new(app, *args, &block) }
      @stack_middlewares = nil
      self
    end

    def execute(app, env)
      stacked = stack_middlewares(app, @chain)
      stacked.call(env)
    end

    protected

    def stack_middlewares(app, chain)
      @stack_middlewares ||= stack_middlewares!(app, chain)
    end

    def stack_middlewares!(app, chain)
      chain.reverse.inject(app) do |app, middle|
        middle.call(app)
      end
    end

  end

end
