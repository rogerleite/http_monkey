require "test_helper"

describe HttpMonkey::Client::Environment do

  subject { HttpMonkey::Client::Environment }

  describe "#accessor" do
    it "gets like Hash" do
      env = subject.new(:test => "value")
      env[:test].must_equal("value")
    end
    it "sets like Hash" do
      env = subject.new(:test => "value")
      env[:test] = "owned"
      env[:test].must_equal("owned")
    end
  end

  it "#http_headers" do
    env = subject.new("HTTP_CONTENT_TYPE" => "text/html",
                      "HTTP_X_CUSTOM" => "custom")

    env.http_headers.must_be_instance_of(Hash)
    env.http_headers["Content-Type"].must_equal("text/html")
    env.http_headers["X-Custom"].must_equal("custom")
  end

end
