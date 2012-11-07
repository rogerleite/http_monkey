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

    def to_env
      uri = @request.url
      rack_input = normalize_body(@request.body)

      env = DEFAULT_ENV.dup
      env = env.merge({
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
      }).update(http_headers)
      env
    end

    # From {"Content-Type" => "text/html"} to {"HTTP_CONTENT_TYPE" => "text/html"}
    def http_headers
      env_headers = @request.headers.map do |key, value|
        ["HTTP_#{key.to_s.upcase.gsub("-", "_")}", value]
      end
      Hash[env_headers]
    end

    def normalize_body(body)
      input = (body.nil? ? "" : body.dup)
      input.force_encoding("ASCII-8BIT") if input.respond_to?(:force_encoding)
      input = StringIO.new(input) if input.is_a?(String)
      input.set_encoding(Encoding::BINARY) if input.respond_to?(:set_encoding)
      input
    end

  end

end
