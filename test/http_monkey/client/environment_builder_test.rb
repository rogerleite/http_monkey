require "test_helper"

describe HttpMonkey::Client::EnvironmentBuilder do

  let(:subject_class) { HttpMonkey::Client::EnvironmentBuilder }
  let(:client) { HttpMonkey.build }

  describe "#to_env" do

    let(:fake_uri) { URI.parse("http://fake.com") }
    let(:stub_request) do
      stub("request",
           :url => fake_uri,
           :body => "body",
           :headers => {"Content-Type" => "plain/text"})
    end

    let(:env) { subject_class.new(client, :get, stub_request).to_env }

    it "body as 'rack.input'" do
      env['rack.input'].must_equal("body")
    end

    it "builds env with uri" do
      env.uri.host.must_equal("fake.com")
    end

    it "sets request method" do
      env['REQUEST_METHOD'].must_equal("GET")
    end

    it "sets 'http_monkey.request'" do
      env['http_monkey.request'].must_equal([:get, stub_request, client])
    end

    it "adds http headers" do
      env['HTTP_CONTENT_TYPE'].must_equal("plain/text")
    end

  end

end
