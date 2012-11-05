require "test_helper"

describe HttpMonkey do

  it "#at" do
    HttpMonkey.at("http://google.com.br").must_be_instance_of(HttpMonkey::EntryPoint)
  end

  it "#configure" do
    HttpMonkey.configure do
      net_adapter :curb
    end
    HttpMonkey.default_client.net_adapter.must_equal(:curb)
  end

  describe "#build" do
    it "wont be same client" do
      HttpMonkey.build.wont_be_same_as(HttpMonkey.default_client)
    end
    it "always return response by default" do
      url = "http://fakeserver.com"
      stub_request(:get, url).to_return(:body => "abc")

      http_client = HttpMonkey.build
      response = http_client.at(url).get
      response.wont_be_nil
      response.body.must_equal("abc")
    end
  end

end
