require "test_helper"

describe HttpMonkey::Client::Environment do

  subject { HttpMonkey::Client::Environment }

  it "must be kind of Hash" do
    subject.new.must_be_kind_of(Hash)
  end

  describe "hash default" do
    it "default non key be nil" do
      env = subject.new("HTTP_CONTENT_TYPE" => "text/html",
                        "HTTP_X_CUSTOM" => "custom")
      env["HTTP_X_CUSTOM"].must_equal("custom")
      env["NON_EXIST"].must_be_nil
    end
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

  describe "#monkey_client" do
    it "with object" do
      stub_client = stub("request")
      env = subject.new("http_monkey.request" => [nil, nil, stub_client])
      env.monkey_client.must_be_same_as(stub_client)
    end
    it "without object" do
      env = subject.new
      env.monkey_client.must_be_nil
    end
  end

  describe "#uri=" do
    it "complete url" do
      env = subject.new
      env.uri = URI.parse("http://localhost:3000/path?q=query")

      env['SERVER_NAME'].must_equal("localhost")
      env['SERVER_PORT'].must_equal("3000")
      env['QUERY_STRING'].must_equal("q=query")
      env['PATH_INFO'].must_equal("/path")
      env['rack.url_scheme'].must_equal("http")
      env['HTTPS'].must_equal("off")
      env['REQUEST_URI'].must_equal("/path?q=query")
      env['HTTP_HOST'].must_equal("localhost")
    end
    it "simple url" do
      env = subject.new
      env.uri = URI.parse("http://localhost")

      env['SERVER_PORT'].must_equal("80")
      env['QUERY_STRING'].must_equal("")
      env['PATH_INFO'].must_equal("/")
    end
    it "https url" do
      env = subject.new
      env.uri = URI.parse("https://localhost:3000")

      env['HTTPS'].must_equal("on")
    end
  end

  describe "#uri" do
    it "valid url" do
      env = subject.new
      env['SERVER_NAME'] = "localhost"
      env['SERVER_PORT'] = "3000"
      env['rack.url_scheme'] = "http"
      env['REQUEST_URI'] = "/path?q=query"

      uri = env.uri
      uri.to_s.must_equal("http://localhost:3000/path?q=query")
    end
    it "invalid url" do
      env = subject.new
      lambda do
        env.uri
      end.must_raise(ArgumentError)
    end
  end

  describe "#request_method" do
    it "with value" do
      env = subject.new('REQUEST_METHOD' => "GET")
      env.request_method.must_equal(:get)
    end
    it "empty" do
      env = subject.new
      env.request_method.must_be_nil
    end
  end

  describe "#storage" do
    it "returns 'http_monkey.storage' key" do
      stub_store = stub("storage")
      env = subject.new('http_monkey.storage' => stub_store)
      env.storage.must_be_same_as(stub_store)
    end
  end

end
