[![Mini logo](https://raw.github.com/rogerleite/http_monkey/gh-pages/images/m1_pb.png)] [![Build Status](https://secure.travis-ci.org/rogerleite/http_monkey.png?branch=master)](https://travis-ci.org/rogerleite/http_monkey)

# HTTP Monkey

A fluent interface to do HTTP calls, free of fat dependencies and at same time, powered by middlewares rack.
* Light and powerful interface
* Flexibility
* Choose your HTTP adapter
* Middlewares (More power to the people!)
* Easy to contribute

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_monkey'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install http_monkey
```

## Usage

[HTTP Monkey home](http://rogerleite.github.com/http_monkey/).

Some code to make developers happy!

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

## Development

Suggestions, bugs and pull requests, use [GitHub Issues](http://github.com/rogerleite/http_monkey/issues).

To see what has changed in recent versions of HTTP Monkey, see the [CHANGELOG](https://github.com/rogerleite/http_monkey/blob/master/CHANGELOG.md).

### Core Team Members

* [Roger Leite](mailto:roger.barreto@gmail.com)

### Copyright

Copyright © 2012 HTTP Monkey. See [LICENSE](https://github.com/rogerleite/http_monkey/blob/master/LICENSE) for details.

Project is a member of the [OSS Manifesto](http://ossmanifesto.com/).
