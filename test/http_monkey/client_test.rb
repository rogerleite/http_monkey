require "test_helper"

describe HttpMonkey::Client do

  subject do
    HttpMonkey::Client.new
  end

  describe "default values" do
    it "#net_adapter" do
      subject.net_adapter.must_equal(:net_http)
    end
  end

  describe "#configure" do
    it "#net_adapter" do
      subject.configure do
        net_adapter(:curb)
      end
      subject.net_adapter.must_equal(:curb)
    end
  end

  describe "#http_request" do

    it "simple request" do
      url = "http://www.google.com.br"
      request = HTTPI::Request.new(url)
      stub_request(:get, url)

      subject.http_request(:get, request)
    end

  end

end
