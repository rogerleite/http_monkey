module HttpMonkey
  module Middlewares
    autoload :DefaultHeaders, "http_monkey/middlewares/default_headers"
    autoload :RequestFilter, "http_monkey/middlewares/request_filter"
    autoload :FollowRedirect, "http_monkey/middlewares/follow_redirect"
  end
  M = Middlewares
end
