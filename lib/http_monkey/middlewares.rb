module HttpMonkey
  module Middlewares
    autoload :DefaultHeaders, "http_monkey/middlewares/default_headers"
    autoload :RequestFilter, "http_monkey/middlewares/request_filter"
  end
end
