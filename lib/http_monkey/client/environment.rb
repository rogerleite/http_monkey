module HttpMonkey

  class Client::Environment

    def initialize(env)
      @env = env
    end

    # From {"HTTP_CONTENT_TYPE" => "text/html"} to {"Content-Type" => "text/html"}
    def http_headers
      req_headers = @env.reject {|k,v| !k.start_with? "HTTP_" }
      normalized = req_headers.map do |key, value|
        new_key = key.sub("HTTP_",'').split('_').map(&:capitalize).join('-')
        [new_key, value]
      end
      Hash[normalized]
    end

  end

  class Client::EnvironmentBuilder

    def initialize(client, method, request)
      @client = client
      @method = method
      @request = request
    end

    def to_env
      uri = @request.url
      env = {
        # rack env default
        'rack.version'      => Rack::VERSION,
        'rack.errors'       => $stderr,
        'rack.multithread'  => true,
        'rack.multiprocess' => false,
        'rack.run_once'     => false,

        # request info
        'REQUEST_METHOD'  => @method.to_s.upcase,
        'SCRIPT_NAME'     => "",
        'PATH_INFO'       => uri.path,
        'QUERY_STRING'    => uri.query || "",
        'SERVER_NAME'     => uri.host,
        'SERVER_PORT'     => (uri.port || uri.inferred_port).to_s,
        'REQUEST_URI'     => uri.request_uri,
        'HTTP_HOST'       => uri.host,
        'rack.url_scheme' => uri.scheme,
        'rack.input'      => @request.body,

        # custom info
        'http_monkey.request' => [@method, @request, @client.net_adapter]
      }.update(http_headers)
      env
    end

    # From {"Content-Type" => "text/html"} to {"HTTP_CONTENT_TYPE" => "text/html"}
    def http_headers
      env_headers = @request.headers.map do |key, value|
        ["HTTP_#{key.to_s.upcase.gsub("-", "_")}", value]
      end
      Hash[env_headers]
    end

  end

end
