module HttpMonkey::Middlewares

  # Allow to set default HTTP headers to all requests
  #
  # Examples
  #
  #   use HttpMonkey::Middlewares::DefaultHeaders, {"Content-Type" => "text/html",
  #                                                 "X-Custom" => "custom"}
  class DefaultHeaders

    def initialize(app, headers = {})
      @app = app
      @headers = headers
    end

    def call(env)
      @headers.each do |header, value|
        http_header = "HTTP_#{header.to_s.upcase.gsub("-", "_")}"
        env[http_header] = value unless env.key?(http_header)
      end
      @app.call(env)
    end

  end

end
