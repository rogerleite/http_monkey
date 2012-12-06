module HttpMonkey

  # Great inspiration from https://github.com/rack/rack/blob/master/lib/rack/mock.rb,
  # specially from Rack::MockRequest
  class Client::EnvironmentBuilder

    DEFAULT_ENV = {
      "rack.version" => Rack::VERSION,
      "rack.input" => nil,
      "rack.errors" => STDERR,
      "rack.multithread" => true,
      "rack.multiprocess" => false,
      "rack.run_once" => false,
      'SCRIPT_NAME'     => "" # call me Suzy
    }

    def initialize(client, method, request)
      @client = client
      @method = method
      @request = request
    end

    # Returns a instance of HttpMonkey::Client::Environment with
    # rack like headers.
    def to_env
      rack_input = normalize_body(@request.body)

      env = HttpMonkey::Client::Environment.new(DEFAULT_ENV)
      env.uri = @request.url

      env.update({
        # request info
        'REQUEST_METHOD'  => @method.to_s.upcase,

        'rack.input'      => rack_input,
        'CONTENT_LENGTH'  => rack_input.length.to_s,

        # custom info
        'http_monkey.request' => [@method, @request, @client],
        'http_monkey.storage' => @client.storage
      })
      env.add_http_header(@request.headers)
      env
    end

    protected

    def normalize_body(body)
      return "" if body.nil?
      input = body.dup
      input.force_encoding("ASCII-8BIT") if input.respond_to?(:force_encoding)
      # TODO: search about setting encoding binary
      #input = StringIO.new(input) if input.is_a?(String)
      #input.set_encoding(Encoding::BINARY) if input.respond_to?(:set_encoding)
      #input = input.string if input.respond_to?(:string)
      input
    end

  end

end
