module HttpMonkey

  class Client::Response < HTTPI::Response

    def initialize(code, headers, body)
      super
      self.headers = HttpObjects::HeadersHash.new(headers)
    end

  end

end
