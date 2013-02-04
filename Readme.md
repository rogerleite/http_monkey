[![Mini logo](https://raw.github.com/rogerleite/http_monkey/gh-pages/images/m1_pb.png)]
# HTTP Monkey [![Build Status](https://secure.travis-ci.org/rogerleite/http_monkey.png?branch=master)](https://travis-ci.org/rogerleite/http_monkey)

A fluent interface to do HTTP calls, free of fat dependencies and at same time, powered by middlewares rack.
* Light and powerful interface
* Flexibility
* Choose your HTTP adapter
* Middlewares (More power to the people!)
* Easy to contribute

Probably you want to see some code to continue ...

``` ruby
  agent = HttpMonkey.build

  # you can set headers, cookies, auth, proxy timeout, SSL ... all web stuff.
  # response = agent.at("http://someservice.com").
  #              with_header("Content-Type" => "application/json").
  #              basic_auth("user", "pass").
  #              get

  response = agent.at("http://google.com").get
  puts response.code  # response.headers and response.body

  # you can change settings on your client
  agent.configure do
    middlewares do
    # Default HTTP Headers (to all requests)
    use HttpMonkey::M::DefaultHeaders, {"Content-Type" => "application/json"}

    # Filter ALL requests (access to env and request objects)
    middlewares.use HttpMonkey::M::RequestFilter do |env, request|
      # HTTPI::Request, you can set proxy, timeouts, authentication etc.
      # req.proxy = "http://proxy.com"
    end

    # Enable automatic follow redirect
    middlewares.use HttpMonkey::M::FollowRedirect, :max_tries => 3
  end

  # or settings by request
  response = agent.at("http://google.com").get do
    net_adapter :curb # [:httpclient, :curb, :net_http, :em_http]
    behaviours do
      on([301, 302]) do |client, request, response|
        raise "Redirect Error"
      end
    end
  end
```

If you liked what you saw, visit http://rogerleite.github.com/http_monkey/ for more information.

Suggestions, bugs and pull requests, use [GitHub Issues](http://github.com/rogerleite/http_monkey/issues).

HTTP Monkey is copyright 2012 Roger Leite and contributors. It is licensed under the MIT license. See the include LICENSE file for details.
