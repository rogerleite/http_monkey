---
layout: default
title: HTTP Monkey by Roger Leite
---

# HTTP Monkey [![Build Status](https://secure.travis-ci.org/rogerleite/http_monkey.png?branch=master)](https://travis-ci.org/rogerleite/http_monkey)

A fluent interface to do HTTP calls, free of fat dependencies and at same time, powered by middlewares rack.

## Light and powerful

{% highlight ruby %}
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

    ## Request Internals (yields HTTPI::Request, to set your obscure desires)
    HttpMonkey.at("http://google.com").yield_request do |req|
      req.proxy = "http://proxy.com"
      req.open_timeout = 30
      req.read_timeout = 15
    end.get

    # SSL
    HttpMonkey.at("http://google.com").yield_request do |req|
      req.auth.ssl.cert_key_file     = "client_key.pem"   # the private key file to use
      req.auth.ssl.cert_key_password = "C3rtP@ssw0rd"     # the key file's password
      req.auth.ssl.cert_file         = "client_cert.pem"  # the certificate file to use
      req.auth.ssl.ca_cert_file      = "ca_cert.pem"      # the ca certificate file to use
      req.auth.ssl.verify_mode       = :none              # or one of [:peer, :fail_if_no_peer_cert, :client_once]
      req.auth.ssl.ssl_version       = :TLSv1             # or one of [:SSLv2, :SSLv3]
    end.get

    # HttpMonkey "built-in" middlewares
    HttpMonkey.configure do
      # Default HTTP Headers (to all requests)
      middlewares.use HttpMonkey::M::DefaultHeaders, {"Content-Type" => "application/json"}

      # Filter ALL requests (access to env and request objects)
      middlewares.use HttpMonkey::M::RequestFilter do |env, request|
        # HTTPI::Request, you can set proxy, timeouts, authentication etc.
        # req.proxy = "http://proxy.com"
      end

      # Enable automatic follow redirect
      middlewares.use HttpMonkey::M::FollowRedirect, :max_tries => 3
    end
{% endhighlight %}

## Flexibility

You can configure the default or build your own client and define how it should behave.

You can also define net adapter, behaviours and middlewares by request.

{% highlight ruby %}
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
        # By default, Monkey raises error. You can catch them, if you want.
        on_error do |client, request, error| do
          # do something with error
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
{% endhighlight %}

## Choose your HTTP client

Thanks to [HTTPI](http://httpirb.com/), you can choose different HTTP clients:

* [HTTPClient](http://rubygems.org/gems/httpclient)
* [Curb](http://rubygems.org/gems/curb)
* [Net::HTTP](http://ruby-doc.org/stdlib/libdoc/net/http/rdoc)

*Important*: If you want to use anything other than Net::HTTP, you need to manually require the library or make sure it’s available in your load path.

{% highlight ruby %}
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
{% endhighlight %}

## More power to the people (for God sake!)

Easy to extend, using the power of Rack middleware interface.

{% highlight ruby %}

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
{% endhighlight %}

You can see my [presentation](http://www.slideshare.net/rogerleite14/http-monkey) in *pt-br* at Editora Abril.

## Easy to contribute

Suggestions, bugs and pull requests, go to [github.com/rogerleite/http_monkey](http://github.com/rogerleite/http_monkey).

If you want to contribute, follow these steps:
* `$ git clone git@github.com:rogerleite/http_monkey.git`
* `$ bundle install`
* `$ rake test`

## License

HTTP Monkey is copyright 2012 Roger Leite and contributors.
It is licensed under the MIT license. See the include LICENSE file for details.
