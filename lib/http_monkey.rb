require "net/http"
require "rack"
require "httpi"
require "http_objects"

require "http_monkey/version"
require "http_monkey/entry_point"
require "http_monkey/configuration"
require "http_monkey/configuration/behaviours"
require "http_monkey/configuration/middlewares"
require "http_monkey/client"
require "http_monkey/client/environment"
require "http_monkey/client/environment_builder"
require "http_monkey/client/response"
require "http_monkey/middlewares"

HTTPI.log = false

module HttpMonkey

  def self.at(url)
    default_client.at(url)
  end

  def self.configure(&block)
    default_client.configure(&block)
  end

  def self.build(&block)
    default_client.build(&block)
  end

  protected

  def self.default_client
    @@default_client ||= HttpMonkey::Client.new.configure do
      net_adapter :net_http
      behaviours do
        # By default, always return response
        on_unknown do |client, request, response|
          response
        end
      end
    end
  end

end
