module HttpMonkey

  # Rack environment with helpers.
  class Client::Environment

    def initialize(env)
      @env = env
    end

    def [](key)
      @env[key]
    end

    def []=(key, value)
      @env[key] = value
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

end
