require "net/http"
require "httpi"

require "http_monkey/version"
require "http_monkey/entry_point"
require "http_monkey/configuration"
require "http_monkey/client"

module HttpMonkey

  def self.at(url)
    HttpMonkey::EntryPoint.new(default_client, url)
  end

  protected

  def self.default_client
    @@default_client ||= build_default_client
  end

  def self.build_default_client
    HttpMonkey::Client.new.configure do

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
