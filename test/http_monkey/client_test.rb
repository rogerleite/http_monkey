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

  it "#clone" do
    subject.configure do
      behaviours.on(200) { "ok" }
    end

    url = "http://www.google.com.br"
    request = HTTPI::Request.new(url)
    stub_request(:get, url)

    response = subject.http_request(:get, request)
    response.must_equal("ok")

    subject_clone = subject.clone.configure do
      behaviours.on(200) { raise "Clone Wars! (this exception cannot be raised)" }
    end
    subject.http_request(:get, request)
  end

end
