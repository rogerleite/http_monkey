require "forwardable"

module HttpMonkey

  module EntryPointFluentInterface

    def with_header(header)
      @request.headers.update(header)
      self
    end
    alias :with_headers :with_header

    def set_cookie(cookie)
      @request.headers["Cookie"] = cookie if cookie
      self
    end
    alias :set_cookies :set_cookie

    def basic_auth(user, pass)
      @request.auth.basic(user, pass)
      self
    end

    def digest_auth(user, pass)
      @request.auth.digest(user, pass)
      self
    end

  end

  class EntryPoint

    def initialize(client, url)
      @client = client
      @request = HTTPI::Request.new(url)
    end

    def _request
      @request
    end

    include EntryPointFluentInterface

    def get(query_param = nil, &block)
      @request.body = query_param
      capture_client(&block).http_request(:get, @request)
    end

    def post(body_param, &block)
      @request.body = body_param
      capture_client(&block).http_request(:post, @request)
    end

    def put(body_param, &block)
      @request.body = body_param
      capture_client(&block).http_request(:put, @request)
    end

    def delete(&block)
      capture_client(&block).http_request(:delete, @request)
    end

    protected

    # If block given, clones actual client and uses
    # the block as configuration
    def capture_client(&block)
      if block_given?
        @client.clone.configure(&block)
      else
        @client
      end
    end
  end

end
