module HttpMonkey

  # Rack environment on steroids! -_-
  # This Hash with super powers is passed to Middlewares.
  #
  # "Snaky" middlewares always remember! "With great power comes great responsibility"
  class Client::Environment < ::Hash

    def initialize(obj = nil, &block)
      super
      self.merge!(obj) unless obj.nil?  # better idea? pull please.
    end

    # Extracts HTTP_ headers from rack environment.
    #
    # Example
    #
    #   env = Client::Environment.new({"HTTP_X_CUSTOM" => "custom"})
    #   env.http_headers  # => {"X-Custom" => "custom"}
    #
    # Returns Hash with normalized http headers.
    def http_headers
      req_headers = self.reject {|k,v| !k.start_with? "HTTP_" }
      normalized = req_headers.map do |key, value|
        new_key = key.sub("HTTP_",'').split('_').map(&:capitalize).join('-')
        [new_key, value]
      end
      Hash[normalized]
    end

    # Sets HTTP header in rack standard way of life.
    #
    # Example
    #
    #   env = Client::Environment.new
    #   env.add_http_header("Content-Type" => "text/html")
    #   env.inspect  # => {"HTTP_CONTENT_TYPE" => "text/html"}
    #
    # Returns nothing important.
    def add_http_header(headers = {})
      headers.each do |key, value|
        self["HTTP_#{key.to_s.upcase.gsub("-", "_")}"] = value
      end
    end

    # Returns HTTPI::Request instance or nil.
    def monkey_request
      if (data = self['http_monkey.request'])
        data[1]
      end
    end

    # Returns HttpMonkey::Client instance or nil.
    def monkey_client
      if (data = self['http_monkey.request'])
        data[2]
      end
    end

  end

end
