require "net/http"
require "rack"
require "httpi"

require "http_monkey/version"
require "http_monkey/entry_point"
require "http_monkey/configuration"
require "http_monkey/configuration/behaviours"
require "http_monkey/configuration/middlewares"
require "http_monkey/client"
require "http_monkey/client/http_request"
require "http_monkey/client/environment"
require "http_monkey/client/environment_builder"

module HttpMonkey

  def self.at(url)
    default_client.at(url)
  end

  def self.configure(&block)
    default_client.configure(&block)
  end

  def self.build(&block)
    HttpMonkey::Client.new.configure(&block)
  end

  protected

  def self.default_client
    @@default_client ||= build do
      net_adapter :net_http
      behaviours do
        # Follow redirects
        on([301, 302, 303, 307]) do |client, request, response|
          if (location = response.headers["location"])
            request.url = location
            client.http_request(:get, request)
          else
            raise "HTTP status #{response.code} not supported (or location not found)"
          end
        end
        # By default, always return response
        on_unknown do |client, request, response|
          response
        end
      end
    end
  end

end

HTTPI.log = false
