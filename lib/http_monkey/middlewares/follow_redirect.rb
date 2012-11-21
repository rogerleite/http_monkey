module HttpMonkey::Middlewares

  # Follow Redirects
  # For response codes [301, 302, 303, 307], follow Location header.
  # If header not found or tries is bigger than +max_tries+, throw RuntimeError.
  #
  # Example
  #
  #   HttpMonkey.configure do
  #     middlewares.use HttpMonkey::M::FollowRedirect, :max_tries => 5 # default: 3
  #   end
  #
  class FollowRedirect

    InfiniteRedirectError = Class.new(StandardError)

    def initialize(app, options = {})
      @app = app
      @max_tries = options.fetch(:max_tries, 3)
      @follow_headers = options.fetch(:headers, [301, 302, 303, 307])
    end

    def call(env)
      current_try = 0
      begin
        code, headers, body = @app.call(env)
        break unless @follow_headers.include?(code)

        location = (headers["Location"] || headers["location"])
        raise RuntimeError, "HTTP status #{code}. No Location header." unless location

        env.uri = URI.parse(location) # change uri and submit again
        current_try += 1
        raise RuntimeError, "Reached the maximum number of attempts in following url." if current_try > @max_tries
      end while true
      [code, headers, body]
    end

  end

end
