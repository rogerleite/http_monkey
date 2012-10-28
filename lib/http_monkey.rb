require "net/http"
require "httpi"

require "http_monkey/version"
require "http_monkey/entry_point"
require "http_monkey/client"

module HttpMonkey

  def self.at(url)
    HttpMonkey::EntryPoint.new(default_client, url)
  end

  protected

  def self.default_client
    @@default_client ||= HttpMonkey::Client.new
  end

end
