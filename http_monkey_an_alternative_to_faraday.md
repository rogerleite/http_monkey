---
layout: default
title: HTTP Monkey an alternative to Faraday
---

# HTTP Monkey an alternative to Faraday

Here are the differences on using [Faraday](https://github.com/lostisland/faraday) and HTTP Monkey.

I hope it helps you adopt HTTP Monkey on your projects. This page is on *draft* status.

## TOC

- [Bare minimum](#bare_minimum)
- [New client](#new_client)
- [GET](#get)
- [POST](#post)
- [Per request options](#perrequest_options)

## Bare minimum

{% highlight ruby %}
  # Faraday
  # using the default stack
  response = Faraday.get 'http://sushi.com/nigiri/sake.json'
{% endhighlight %}

{% highlight ruby %}
  # HTTP Monkey
  # using the default stack
  response = HttpMonkey.at('http://sushi.com/nigiri/sake.json').get
{% endhighlight %}
[TOC](#toc)

## New client

{% highlight ruby %}
  # Faraday
  fconn = Faraday.new(:url => 'http://sushi.com') do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to STDOUT
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end
{% endhighlight %}

{% highlight ruby %}
  # HTTP Monkey
  mconn = HttpMonkey.build.configure do
    middlewares do
      #use ExternalMiddleware::UrlEncoded  # Imaginary middleware
      #use ExternalMiddleware::Logger      # Imaginary middleware
    end
    net_adapter :net_http # [:httpclient, :curb, :net_http, :em_http], default: :net_http
  end
{% endhighlight %}
[TOC](#toc)

### GET

{% highlight ruby %}
  # Faraday
  fconn.get '/nigiri/sake.json'                # GET http://sushi.com/nigiri/sake.json
  fconn.get '/nigiri', { :name => 'Maguro' }   # GET /nigiri?name=Maguro
  fconn.get do |req|                           # GET http://sushi.com/search?page=2&limit=100
    req.url '/search', :page => 2
    req.params['limit'] = 100
  end
{% endhighlight %}

{% highlight ruby %}
  # HTTP Monkey
  mconn.at('http://sushi.com/nigiri/sake.json').get                   # GET http://sushi.com/nigiri/sake.json
  mconn.at('http://sushi.com/nigiri').get(:name => 'Maguro')          # GET /nigiri?name=Maguro
  mconn.at('http://sushi.com/search').get(:page => 2, :limit => 100)  # GET http://sushi.com/search?page=2&limit=100
{% endhighlight %}
[TOC](#toc)

### POST

{% highlight ruby %}
  # Faraday
  fconn.post '/nigiri', { :name => 'Maguro' }  # POST "name=maguro" to http://sushi.com/nigiri
  # post payload as JSON instead of "www-form-urlencoded" encoding:
  fconn.post do |req|
    req.url '/nigiri'
    req.headers['Content-Type'] = 'application/json'
    req.body = '{ "name": "Unagi" }'
  end
{% endhighlight %}

{% highlight ruby %}
  # HTTP Monkey
  mconn.at('http://sushi.com/nigiri').post(:name => 'Maguro')  # POST "name=maguro" to http://sushi.com/nigiri
  # post payload as JSON instead of "www-form-urlencoded" encoding:
  mconn.at('http://sushi.com/nigiri').
    with_header('Content-Type' => 'application/json').
    post('{ "name": "Unagi" }')
{% endhighlight %}
[TOC](#toc)

### Per-request options

{% highlight ruby %}
  # Faraday
  fconn.get do |req|
    req.url '/search'
    # this req options didn't work with faraday (0.8.4)
    #req.options.timeout = 5           # open/read timeout in seconds
    #req.options.open_timeout = 2      # connection open timeout in seconds

    # set proxy with string
    #req.options.proxy = "http://user:password@example.org/"

    # set proxy with hash
    #req.options.proxy = { :uri => 'http://user:passwordexample.org' }

    # specify proxy user/pass
    #req.options.proxy = { :uri => 'http://user:pass.org',
    #  :user => 'user',
    #  :password => 'pass' }
  end
{% endhighlight %}

{% highlight ruby %}
  # HTTP Monkey
  begin
    mconn.at('http://sushi.com/search').yield_request do |req|
      req.open_timeout = 2
      req.read_timeout = 5
      req.proxy = "http://proxy.com"
      req.proxy = "http://user:pass@proxy.com"
    end.get
  rescue => ex
    puts "Expected because invalid proxy: #{ex.message}"
  end
{% endhighlight %}
[TOC](#toc)
