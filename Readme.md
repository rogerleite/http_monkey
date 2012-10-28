# HTTP Monkey

A fluent interface to do HTTP calls, free of fat dependencies and at same time, powered by middlewares rack.

It's an awesome client with an awful name.

## Light and powerful

``` ruby
    # Works with Entry Point concept
    response = HttpMonkey.at("http://google.com").get
    response = HttpMonkey.at("http://google.com").post(:q => "Http Monkey!")
    puts response.body  # More info about response at http://httpirb.com/#responses

    ## Headers
    HttpMonket.at("http://google.com").
      with_header("Content-Type" => "text/html").
      with_header("X-Custom" => "sample").
      get

    ## Cookies
    HttpMonkey.at("http://google.com").set_cookie("blah").get

    ## Basic Authentication
    HttpMonkey.at("http://user:pass@google.com").get
    HttpMonkey.at("http://google.com").
      basic_auth("user", "pass").
      get
```

## Flexibility

You can configure the default or build your own client and define how it should behave.

You can also define net adapter, behaviours and middlewares by request.

``` ruby
    # Changing default client
    HttpMonkey.configure do
      net_adapter :curb
      behaviours.on(500) do |client, request, response|
        raise "Server side error :X"
      end
    end

    # Works with status code callbacks (here known as behaviours)
    chimp = HttpMonkey.build do
      behaviours do
        # 2xx range
        on(200..299) do |client, request, response|
          response
        end
        # Redirects
        on([301, 302]) do |client, request, response|
          raise "Redirect error"
        end
      end
    end

    chimp.at("http://google.com").get  # raises Redirect error

    # by request
    chimp.at("http://google.com").get do
      behaviours.on(200) do |client, request, response|
        raise "ok" # only for this request
      end
    end
```

## Choose your HTTP client

Thanks to [HTTPI](http://httpirb.com/), you can choose different HTTP clients:

* [HTTPClient](http://rubygems.org/gems/httpclient)
* [Curb](http://rubygems.org/gems/curb)
* [Net::HTTP](http://ruby-doc.org/stdlib/libdoc/net/http/rdoc)

*Important*: If you want to use anything other than Net::HTTP, you need to manually require the library or make sure it’s available in your load path.

``` ruby
    # When you build your own client, you can define which Http client to use.
    chimp = HttpMonkey.build do
      # HTTP clients available [:httpclient, :curb, :net_http]
      net_adapter :curb  # default :net_http
      # [...]
    end

    # You can also change you net_adapter by request
    chimp.at("http://google.com").get do
      # only on this request, use :httpclient
      net_adapter :httpclient
      # [...]
    end
```

## More power to the people (for God sake!)

Easy to extend, using the power of Rack middleware interface.

``` ruby

    class Logger
      def initialize(app)
        @app = app
      end
      def call(env)
        puts "-> before #{env.inspect} #{Time.now.inspect}"
        result = @app.call(env)
        puts "-> after #{env.inspect} #{Time.now.inspect}"
        result
      end
    end

    # Add custom middlewares to default stack
    HttpMonkey.configure do
      middlewares do
        use Logger
      end
    end
    # Now all requests uses Logger
    response = HttpMonkey.at("http://google.com").get

    # or when you build your own client
    chimp = HttpMonkey.build do
      middlewares do
        use Logger
      end
    end

    # or by request
    chimp.at("http://google.com").get do
      middlewares.use Logger
      # [...]
    end
```

Some ideas:

* Cache? [rack-cache](https://github.com/rtomayko/rack-cache)
* Logger? [http://rack.rubyforge.org/doc/Rack/Logger.html]
* Profile?
* Support to specific Media Type?

## Easy to contribute

Suggestions, bugs and pull requests, here at [github.com/rogerleite/http_monkey](http://github.com/rogerleite/http_monkey).
`bundle install`, `rake test` and be happy!

## License

HTTP Monkey is copyright 2012 Roger Leite and contributors. It is licensed under the MIT license. See the include LICENSE file for details.
