module HttpMonkey::Support

  module FakeEnvironment

    def fake_request
      @fake_request ||= stub("request")
    end

    def fake_client
      @fake_client ||= stub("client")
    end

    def fake_env
      @fake_env ||= begin
                      env = {'http_monkey.request' => [nil, fake_request, fake_client]}
                      HttpMonkey::Client::Environment.new(env)
                    end
    end

  end

end
