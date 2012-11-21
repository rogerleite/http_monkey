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
require "http_monkey/middlewares"

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
        # By default, always return response
        on_unknown do |client, request, response|
          response
        end
      end
    end
  end

end

HTTPI.log = false

# This monkey patch is to avoid a bug from httpi (1.1.1) on ruby 1.8.7
# that raises "undefined method `use_ssl=' for Net::HTTP"
if RUBY_VERSION =~ /1\.8/
  class Net::HTTPSession
    def use_ssl=(flag)
    end
  end
end
