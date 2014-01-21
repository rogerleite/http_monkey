require "test_helper"

describe HttpMonkey::EntryPoint do

  TEST_URL = "https://www.google.com.br"

  before do
    @mock_client = stub("client")
  end

  subject do
    HttpMonkey::EntryPoint.new(@mock_client, TEST_URL)
  end

  def expects_request_on(client, method, body, &block)
    client.expects(:http_request).with do |method, request|
      if block.respond_to?(:call)
        block_assertion = block.call(method, request)
      else
        block_assertion = true
      end

      request_url = request.url.select(:scheme, :host).join("://")

      body_assertion = false
      if body.nil?
        body_assertion = request.body.must_be_nil
      elsif body.is_a?(String)
        body_assertion = request.body.must_equal(body)
      elsif body.is_a?(Regexp)
        body_assertion = request.body.must_match(body)
      end

      block_assertion && \
        method.must_equal(method) && \
        request_url.must_equal(TEST_URL) && \
        request.must_be_instance_of(HTTPI::Request) && \
        body_assertion
    end
  end

  it "#get" do
    expects_request_on(@mock_client, :get, nil)
    subject.get
  end

  it "#get with parameters" do
    expects_request_on(@mock_client, :get, nil) do |method, request|
      request.url.query.must_match(/(p1=param1&p2=param2)|(p2=param2&p1=param1)/)
    end

    subject.get(:p1 => "param1", :p2 => "param2")
  end

  it "#post with parameters" do
    expects_request_on(@mock_client, :post, /(b1=param1&b2=param2)|(b2=param2&b1=param1)/)
    subject.post(:b1 => "param1", :b2 => "param2")
  end

  it "#put with parameters" do
    expects_request_on(@mock_client, :put, /(p1=param1&p2=param2)|(p2=param2&p1=param1)/)
    subject.put(:p1 => "param1", :p2 => "param2")
  end

  it "#patch with parameters" do
    expects_request_on(@mock_client, :patch, /(p1=param1&p2=param2)|(p2=param2&p1=param1)/)
    subject.patch(:p1 => "param1", :p2 => "param2")
  end

  it "#delete" do
    expects_request_on(@mock_client, :delete, nil)
    subject.delete
  end

  it "HTTP requests should accept configuration block" do
    block = lambda { raise "Not to be raised" }
    @mock_client.expects(:clone).returns(@mock_client)
    @mock_client.expects(:configure).returns(@mock_client)
    expects_request_on(@mock_client, :get, nil)

    subject.get(&block)
  end

  describe "FluentInterface -_-" do

    it "#with_header" do
      expects_request_on(@mock_client, :get, nil) do |method, request|
        request.headers.must_equal({"Content-Type" => "text/html", "X-Custom" => "sample"})
      end
      subject.with_header("Content-Type" => "text/html").
        with_header("X-Custom" => "sample").
        get
    end

    it "#with_headers" do
      expects_request_on(@mock_client, :get, nil) do |method, request|
        request.headers.must_equal({"Content-Type" => "text/html", "X-Custom" => "sample"})
      end
      subject.with_headers("Content-Type" => "text/html",
                           "X-Custom" => "sample").get
    end

    it "#set_cookie" do
      expects_request_on(@mock_client, :get, nil) do |method, request|
        request.headers["Cookie"].must_equal("name=value;name2=value2")
      end
      subject.set_cookie("name=value;name2=value2").get
    end

    it "#basic_auth" do
      expects_request_on(@mock_client, :get, nil) do |method, request|
        request.auth.type.must_equal(:basic) && \
          request.auth.credentials.must_equal(["mad", "max"])
      end
      subject.basic_auth("mad", "max").get
    end

    it "#digest_auth" do
      expects_request_on(@mock_client, :get, nil) do |method, request|
        request.auth.type.must_equal(:digest) && \
          request.auth.credentials.must_equal(["mad", "max"])
      end
      subject.digest_auth("mad", "max").get
    end

    it "#yield_request" do
      expects_request_on(@mock_client, :get, nil) do |method, request|
        request.proxy.to_s.must_equal("http://proxy.com") && \
          request.open_timeout.must_equal(30) && \
          request.read_timeout.must_equal(15)
      end
      subject.yield_request do |req|
        req.proxy = "http://proxy.com"
        req.open_timeout = 30
        req.read_timeout = 15
      end.get
    end
  end

end
