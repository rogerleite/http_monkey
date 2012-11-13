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
    }

    def initialize(client, method, request)
      @client = client
      @method = method
      @request = request
    end

    # Returns a instance of HttpMonkey::Client::Environment with
    # rack like headers.
    def to_env
      uri = @request.url
      rack_input = normalize_body(@request.body)

      env = HttpMonkey::Client::Environment.new(DEFAULT_ENV)
      env.update({
        # request info
        'REQUEST_METHOD'  => @method.to_s.upcase,
        'SERVER_NAME'     => uri.host,
        'SERVER_PORT'     => (uri.port || uri.inferred_port).to_s,
        'QUERY_STRING'    => uri.query || "",
        'PATH_INFO'       => (!uri.path || uri.path.empty?) ? "/" : uri.path,
        'rack.url_scheme' => uri.scheme,
        'HTTPS'           => (uri.scheme == "https" ? "on" : "off"),
        'SCRIPT_NAME'     => "", # call me Suzy

        'REQUEST_URI'     => uri.request_uri,
        'HTTP_HOST'       => uri.host,
        'rack.input'      => rack_input,
        'CONTENT_LENGTH'  => rack_input.length.to_s,

        # custom info
        'http_monkey.request' => [@method, @request, @client.net_adapter]
      })
      env.add_http_header(@request.headers)
      env
    end

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
