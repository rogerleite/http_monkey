require "test_helper"

describe HttpMonkey::Client::Environment do

  subject { HttpMonkey::Client::Environment }

  it "must be kind of Hash" do
    subject.new.must_be_kind_of(Hash)
  end

  describe "#http_headers" do
    it "empty env must return empty Hash" do
      http_headers = subject.new.http_headers
      http_headers.must_be_empty
    end
    it "must list HTTP Headers" do
      env = subject.new("HTTP_CONTENT_TYPE" => "text/html",
                        "HTTP_X_CUSTOM" => "custom")

      http_headers = env.http_headers
      http_headers["Content-Type"].must_equal("text/html")
      http_headers["X-Custom"].must_equal("custom")
    end
  end

  it "#add_http_header" do
    env = subject.new("HTTP_CONTENT_TYPE" => "text/html")

    env.add_http_header("Content-Type" => "application/json",
                        "X-Custom" => "custom")
    env["HTTP_CONTENT_TYPE"].must_equal("application/json")
    env["HTTP_X_CUSTOM"].must_equal("custom")
  end

  describe "#monkey_request" do
    it "with object" do
      stub_req = stub("request")
      env = subject.new("http_monkey.request" => [nil, stub_req, nil])
      env.monkey_request.must_be_same_as(stub_req)
    end
    it "without object" do
      env = subject.new
      env.monkey_request.must_be_nil
    end
  end

end
